⛵ Todos a Bordo – Analítica del Mercado de Alquiler de Barcos

Bienvenido a Todos a Bordo, un proyecto de Data Analytics sobre el mercado de alquiler de embarcaciones recreativas en España.

Nuestro análisis se centra en tres zonas muy distintas entre sí:

Ibiza 🏝️ – turismo de alta gama y clima estable

A Coruña 🌬️ – clima más fresco, influencia atlántica

Málaga ☀️ – turismo masivo y gran estacionalidad

El objetivo es explorar cómo influyen el turismo, el clima y la presión de la demanda en la oferta y los precios del mercado náutico.

🎯 Objetivo del Proyecto

Analizar la disponibilidad y el precio del alquiler de barcos en función de:

Ubicación → Ibiza, A Coruña y Málaga

Meses de verano (alta demanda)

Condiciones climáticas

Magnitud del turismo (nacional e internacional)

Las fuentes de datos son:

Click&Boat para barcos y precios

Dataestur para presión turística

Datasets propios limpiados en xlsx y notebooks asociados

📌 Hipótesis del análisis

1️⃣ Las zonas con mejor clima veraniego presentan precios más altos en alquiler de barcos.
2️⃣ Las zonas con mayor presión turística muestran un mayor coste medio.
3️⃣ Las zonas más ventosas/frescas tienen mayor proporción de veleros; las cálidas, más lanchas.

Estas hipótesis permiten entender si el “precio del mar” está guiado por clima, demanda o perfil del turista.

🧮 Consideraciones Metodológicas Importantes

Los datos turísticos proceden de Dataestur, pero en algunos casos no están disponibles por provincia específica. Por ello:

✔ Illes Balears (para Ibiza)

Dataestur solo publica cifras agregadas a nivel isla/comunidad.
Para asignar Ibiza dentro de Illes Balears se aplica un coeficiente proporcional.

Por defecto en este proyecto:

Ibiza = 30% del total de Illes Balears

Este factor se puede cambiar fácilmente en el código.
Documentamos esta decisión para mantener transparencia metodológica.

✔ Galicia (para A Coruña)

Dataestur también ofrece datos agregados por comunidad autónoma.
Se aplica un reparto basado en una proporción inicial:

A Coruña = 40% del total Galicia

Este factor se ajustará si se dispone de fuentes más precisas.

✔ Málaga

Los datos están disponibles directamente a nivel provincial, por lo que no requieren reparto.

💡 El objetivo es mantener la trazabilidad del origen del dato y garantizar que las transformaciones de agregación no introducen opacidad en el análisis.

🧰 Componentes del Proyecto
🔍 1. Web Scraping

Extracción de embarcaciones por zona

Precio, tipo, eslora, capacidad, antigüedad

Selenium + BeautifulSoup

🧽 2. Data Cleaning

Limpieza y estandarización de columnas

Conversión de precios y normalización

Exportación final en XLSX

📊 3. Exploración y análisis

Comparación entre zonas

Estacionalidad turística y climática

Distribución de precios por zona y categoría

📎 Tecnologías utilizadas

Python

Selenium / BeautifulSoup

Pandas

Jupyter Notebooks

Excel

Git + GitHub
