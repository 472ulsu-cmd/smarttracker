#!/usr/bin/env python3
"""Генератор assets/cities/cities.csv из GeoNames.

Скачивает cities15000.zip и alternateNamesV2.zip, фильтрует города
РФ/Казахстана/Беларуси с населением >= 50000 и пишет CSV в формате
name,lat,lng,countryCode, отсортированный по убыванию населения.

Названия городов — русские. Поле name в cities15000.txt содержит латиницу,
а поле alternatenames — смесь локализаций без тегов языка, поэтому русское
название берётся из alternateNamesV2.txt по связке isolanguage == 'ru' +
geonameid (приоритет у isPreferredName=1). Города без русской локализации
пропускаются — приложение для водителей на русском, латиница в nearest_city
недопустима.

Скачанные архивы кэшируются в tool/.cache/ (в .gitignore) — повторные запуски
не тянут ~200 МБ alternateNamesV2.zip заново.

Запуск:  python tool/generate_cities.py
Результат перезаписывает assets/cities/cities.csv (UTF-8, без BOM, без заголовка).

Источники:
  https://download.geonames.org/export/dump/cities15000.zip
  https://download.geonames.org/export/dump/alternateNamesV2.zip
"""

import csv
import io
import re
import sys
import urllib.request
import zipfile
from pathlib import Path

CITIES_URL = "https://download.geonames.org/export/dump/cities15000.zip"
ALT_NAMES_URL = "https://download.geonames.org/export/dump/alternateNamesV2.zip"
MIN_POPULATION = 50000
COUNTRIES = {"RU", "KZ", "BY"}
ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT.parent / "assets" / "cities" / "cities.csv"
CACHE_DIR = ROOT / ".cache"

# Индексы колонок GeoNames cities15000.txt (0-based).
C_GEONAMEID = 0
C_NAME = 1
C_LAT = 4
C_LNG = 5
C_COUNTRY = 8
C_POPULATION = 14

# Индексы колонок alternateNamesV2.txt (0-based).
A_GEONAMEID = 1
A_ISOLANGUAGE = 2
A_ALT_NAME = 3
A_IS_PREFERRED = 4

# Кириллица в названии: в alternateNamesV2 бывают ru-варианты с латиницей
# и апострофами (например "Stavropol'"), а чисто русское "Ставрополь" может
# идти не первым. Поэтому среди ru-вариантов предпочитаем кириллический.
_CYRILLIC = re.compile(r"[А-Яа-яЁё]")


def download_cached(url, filename):
    """Скачивает url в CACHE_DIR/filename, использует кэш при повторных запусках."""
    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    dest = CACHE_DIR / filename
    if dest.exists():
        print(f"кэш: {dest} уже скачан", file=sys.stderr)
        return dest
    print(f"скачиваю {url} ...", file=sys.stderr)
    with urllib.request.urlopen(url) as resp, open(dest, "wb") as f:
        f.write(resp.read())
    print(f"сохранено в {dest}", file=sys.stderr)
    return dest


def iter_zip_text(zip_path, inner_suffix):
    """Открывает zip и возвращает итератор декодированных строк inner-файла."""
    with zipfile.ZipFile(zip_path) as zf:
        names = [n for n in zf.namelist() if n.endswith(inner_suffix)]
        if not names:
            raise RuntimeError(f"файл *{inner_suffix} не найден в {zip_path}")
        with zf.open(names[0]) as f:
            for raw in f:
                yield raw.decode("utf-8", errors="replace")


def load_cities():
    """Города из cities15000, прошедшие фильтр страны/населения.

    Возвращает список dict-ов с ключами geonameid, name, lat, lng, country,
    population.
    """
    zip_path = download_cached(CITIES_URL, "cities15000.zip")
    cities = []
    for line in iter_zip_text(zip_path, "cities15000.txt"):
        fields = line.split("\t")
        if len(fields) <= C_POPULATION:
            continue
        if fields[C_COUNTRY].strip() not in COUNTRIES:
            continue
        try:
            lat = float(fields[C_LAT])
            lng = float(fields[C_LNG])
            population = int(fields[C_POPULATION] or 0)
        except ValueError:
            continue
        if population < MIN_POPULATION:
            continue
        cities.append({
            "geonameid": fields[C_GEONAMEID].strip(),
            "name": fields[C_NAME].strip(),
            "lat": lat,
            "lng": lng,
            "country": fields[C_COUNTRY].strip(),
            "population": population,
        })
    return cities


def build_russian_names(geonameids):
    """Map geonameid → русское название из alternateNamesV2.

    Среди вариантов с isolanguage == 'ru' выбираем лучший по приоритету:
    1) кириллический preferred (если есть),
    2) любой кириллический,
    3) preferred ru (даже если латиница),
    4) первый ru.
    В alternateNamesV2 встречаются «ru»-варианты с латиницей и апострофами
    (например "Stavropol'") — отсюда требование предпочитать кириллицу.
    """
    zip_path = download_cached(ALT_NAMES_URL, "alternateNamesV2.zip")
    # gid → (cyrillic?, preferred?, name) — выбираем max по кортежу.
    best = {}
    for line in iter_zip_text(zip_path, "alternateNamesV2.txt"):
        fields = line.split("\t")
        if len(fields) <= A_IS_PREFERRED:
            continue
        gid = fields[A_GEONAMEID].strip()
        if gid not in geonameids:
            continue
        if fields[A_ISOLANGUAGE].strip() != "ru":
            continue
        name = fields[A_ALT_NAME].strip()
        if not name:
            continue
        is_preferred = fields[A_IS_PREFERRED].strip() == "1"
        is_cyrillic = bool(_CYRILLIC.search(name))
        key = (is_cyrillic, is_preferred)
        existing = best.get(gid)
        if existing is None or key > existing[0]:
            best[gid] = (key, name)
    return {gid: name for gid, (_key, name) in best.items()}


def main():
    cities = load_cities()
    geonameids = {c["geonameid"] for c in cities}
    ru_names = build_russian_names(geonameids)

    # Города без русской локализации пропускаем — приложение для водителей на
    # русском, латиница в nearest_city недопустима (выявленные артефакты
    # GeoNames: Obruchevo, Kisilevsk, Kurortnyy и т. п. — микрорайоны/районы
    # с завышенным population, для которых нет ru-варианта).
    total = len(cities)
    cities = [c for c in cities if c["geonameid"] in ru_names]
    for c in cities:
        c["display_name"] = ru_names[c["geonameid"]]

    # По убыванию населения — крупные города первыми.
    cities.sort(key=lambda c: c["population"], reverse=True)

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    # newline="" — стандартный рецепт csv в Python 3 (корректные переводы строк).
    with open(OUTPUT, "w", encoding="utf-8", newline="") as f:
        writer = csv.writer(f)
        for c in cities:
            writer.writerow([c["display_name"], c["lat"], c["lng"], c["country"]])

    skipped = total - len(cities)
    print(
        f"Готово: записано {len(cities)} городов "
        f"(пропущено {skipped} без русской локализации) в {OUTPUT}",
        file=sys.stderr,
    )


if __name__ == "__main__":
    main()
