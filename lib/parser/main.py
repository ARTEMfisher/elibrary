import requests
from bs4 import BeautifulSoup
import json

# Создаём список для хранения данных со всех страниц
all_products = []
id = 0
# Цикл по страницам от 1 до 36
for page in range(1, 35):
    # URL страницы с подстановкой номера
    url = f"https://www.chitai-gorod.ru/catalog/books/hudozhestvennaya-literatura-110001?page={page}&sortPreset=reviewsDesc&filters%5Bpublishers%5D=118732&filters%5BpublisherSeries%5D=213099&filters%5BpublisherSeries%5D=90197&filters%5BpublisherSeries%5D=73232&filters%5Bbindings%5D=619286947"

    # Отправляем запрос к странице
    response = requests.get(url)

    # Проверяем успешность запроса
    if response.status_code == 200:
        # Парсим страницу
        soup = BeautifulSoup(response.text, 'html.parser')

        # Ищем все элементы с классом "product"
        product_divs = soup.find_all('article', class_='product-card product-card product')

        # Проходим по каждому продукту на странице
        for product in product_divs:
            # Находим название продукта
            title = product.find('div', class_='product-title__head').text.strip()

            # Находим автора продукта
            author = product.find('div', class_='product-title__author').text.strip()

            # Находим ссылку на картинку
            image_url = product.find('img').get('data-src')
            if title and author and image_url:

                # Добавляем данные в список

                all_products.append({
                    'id': id,
                    'title': title,
                    'author': author,
                    'image_url': image_url,
                    'holders': [],
                    'isFree':'true'
                })
                id+=1


        print(f"Страница {page} успешно обработана")
    else:
        print(f"Ошибка при получении страницы {page}: {response.status_code}")

# Сохраняем все данные в JSON файл после завершения парсинга всех страниц
with open('books.json', 'w', encoding='utf-8') as f:
    json.dump(all_products, f, ensure_ascii=False, indent=4)

print("Все данные успешно сохранены в all_products.json")

