#!/usr/bin/env python3

import json
import urllib.request
import os
import time
import sys
from pathlib import Path

# ================= CONFIGURACIÓN =================
# Lista de criptomonedas (nombres oficiales de CoinGecko)
CRYPTO_LIST = ["bitcoin", "ethereum", "tether", "binancecoin", "solana"]

# Archivos de estado
STATE_FILE = "/tmp/polybar_crypto_index"
CACHE_FILE = "/tmp/polybar_crypto_cache.json"
CACHE_MINUTES = 10  # Actualizar precios cada 5 minutos

# Tu API Key de CoinGecko (cámbiala por la tuya)
API_KEY = "CG-nmtYiptgCPSZHchTb68YZsrB"
HEADERS = {'x-cg-demo-api-key': API_KEY}

# URL de CoinGecko para mercado (cambio 1h)
CRYPTO_IDS = ','.join(CRYPTO_LIST)
CRYPTO_URL = f"https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids={CRYPTO_IDS}&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=1h"

TIMEOUT = 15

# ================= FUNCIONES =================
def fetch_json(url):
    req = urllib.request.Request(url, headers=HEADERS)
    with urllib.request.urlopen(req, timeout=TIMEOUT) as response:
        return json.loads(response.read().decode())

def get_crypto_data():
    try:
        data = fetch_json(CRYPTO_URL)
        prices = {}
        for item in data:
            crypto_id = item['id']
            change = item.get('price_change_percentage_1h_in_currency')
            if change is None:
                change = 0.0
            prices[crypto_id] = {
                'price': item['current_price'],
                'change': change
            }
        return prices
    except Exception as e:
        print(f"Error obteniendo datos: {e}", file=sys.stderr)
        return None

def is_cache_fresh():
    if not os.path.exists(CACHE_FILE):
        return False
    age = time.time() - os.path.getmtime(CACHE_FILE)
    return age < (CACHE_MINUTES * 60)

def load_or_fetch():
    if is_cache_fresh():
        with open(CACHE_FILE, 'r') as f:
            return json.load(f)
    else:
        data = get_crypto_data()
        if data:
            with open(CACHE_FILE, 'w') as f:
                json.dump(data, f)
        return data

def format_change(change):
    if change > 0:
        return f"%{{F#A6E22E}}▲{change:.1f}%%{{F-}}"
    elif change < 0:
        return f"%{{F#F92672}}▼{change:.1f}%%{{F-}}"
    else:
        return "%{F#FFFFFF}•0.0%%{F-}"

def format_crypto(crypto_id, price, change):
    icons = {
        "bitcoin": "₿",
        "ethereum": "Ξ",
        "tether": "₮",
        "binancecoin": "BNB",
        "solana": "◎"
    }
    icon = icons.get(crypto_id, crypto_id.capitalize())
    change_str = format_change(change)
    formatted_price = f"${price:,.2f}".replace(",", ".")
    return f"{icon} {formatted_price} {change_str}"

def main():
    data = load_or_fetch()
    if not data:
        print("Error: No se pudieron obtener los datos")
        return

    items = []
    for crypto in CRYPTO_LIST:
        if crypto in data:
            items.append(format_crypto(crypto, data[crypto]['price'], data[crypto]['change']))

    if not items:
        print("No data")
        return

    # Carrusel
    idx = 0
    if os.path.exists(STATE_FILE):
        with open(STATE_FILE, 'r') as f:
            try:
                idx = int(f.read().strip())
                idx = idx % len(items)
            except:
                idx = 0

    print(items[idx])

    next_idx = (idx + 1) % len(items)
    with open(STATE_FILE, 'w') as f:
        f.write(str(next_idx))

if __name__ == "__main__":
    main()
