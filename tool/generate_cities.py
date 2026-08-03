#!/usr/bin/env python3
"""Генератор assets/cities/cities.csv из GeoNames.

Скачивает cities15000.zip, фильтрует города РФ/Казахстана/Беларуси
с населением >= 50000 и пишет CSV в формате name,lat,lng,countryCode,
отсортированный по убыванию населения.

Запуск:  python tool/generate_cities.py
Результат перезаписывает assets/cities/cities.csv (UTF-8, без BOM, без заголовка).

Источник: https://download.geonames.org/export/dump/cities15000.zip
"""

import csv
import io
import sys
import urllib.request
import zipfile
from pathlib import Path

URL = "https://download.geonames.org/export/dump/cities15000.zip"
MIN_POPULATION = 50000
COUNTRIES = {"RU", "KZ", "BY"}
OUTPUT = Path(__file__).resolve().parent.parent / "assets" / "cities" / "cities.csv"

# Индексы колонок GeoNames cities15000.txt (0-based).
COL_NAME = 1
COL_LAT = 4
COL_LNG = 5
COL_COUNTRY = 8
COL_POPULATION = 14


def fetch_rows():
    """Скачивает архив и возвращает итератор сырых строк cities15000.txt."""
    with urllib.request.urlopen(URL) as resp:
        data = resp.read()
    with zipfile.ZipFile(io.BytesIO(data)) as zf:
        # В архиве один файл cities15000.txt.
        names = [n for n in zf.namelist() if n.endswith("cities15000.txt")]
        if not names:
            raise RuntimeError("cities15000.txt не найден в архиве")
        with zf.open(names[0]) as f:
            for raw in f:
                yield raw.decode("utf-8", errors="replace")


def parse_row(line):
    """Разбирает TSV-строку GeoNames → (name, lat, lng, country, population)."""
    fields = line.split("\t")
    if len(fields) <= COL_POPULATION:
        return None
    try:
        lat = float(fields[COL_LAT])
        lng = float(fields[COL_LNG])
        population = int(fields[COL_POPULATION] or 0)
    except ValueError:
        return None
    return (
        fields[COL_NAME].strip(),
        lat,
        lng,
        fields[COL_COUNTRY].strip(),
        population,
    )


def main():
    cities = []
    total = 0
    for line in fetch_rows():
        line = line.rstrip("\n")
        if not line:
            continue
        total += 1
        row = parse_row(line)
        if row is None:
            continue
        name, lat, lng, country, population = row
        if country not in COUNTRIES:
            continue
        if population < MIN_POPULATION:
            continue
        cities.append((name, lat, lng, country, population))

    # По убыванию населения — крупные города первыми.
    cities.sort(key=lambda c: c[4], reverse=True)

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    # newline="" — стандартный рецепт csv в Python 3 (корректные переводы строк).
    with open(OUTPUT, "w", encoding="utf-8", newline="") as f:
        writer = csv.writer(f)
        for name, lat, lng, country, _ in cities:
            writer.writerow([name, lat, lng, country])

    print(
        f"Готово: записано {len(cities)} городов (из {total} строк GeoNames) "
        f"в {OUTPUT}",
        file=sys.stderr,
    )


if __name__ == "__main__":
    main()
