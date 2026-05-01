# 🏨 Análisis de Cancelaciones en Reservas de Hoteles (EDA en SQL)

Dataset: https://www.kaggle.com/datasets/mojtaba142/hotel-booking

---

## 📌 Descripción del Proyecto

Este proyecto desarrolla un **Análisis Exploratorio de Datos (EDA) utilizando SQL** sobre un dataset de reservas hoteleras, con el objetivo de **identificar y explicar los factores que influyen en la cancelación de reservas** desde una perspectiva analítica y de negocio.

El dataset contiene **119.390 registros y 32 variables**, donde cada fila representa una reserva individual realizada en dos tipos de hotel: **City Hotel** y **Resort Hotel**. Las reservas abarcan el período entre **julio de 2015 y agosto de 2017**, e incluyen tanto reservas completadas como canceladas.


La variable objetivo es:

- `is_canceled` → indica si la reserva fue cancelada (1) o no (0)

El enfoque del proyecto no solo se centra en explorar los datos, sino en **traducir consultas SQL en insights accionables**, permitiendo detectar patrones de riesgo, segmentar clientes y comprender cómo distintas variables impactan en la probabilidad de cancelación.

---

## 🎯 Objetivo de Negocio

En la industria hotelera, las cancelaciones impactan directamente en:

- 💸 Ingresos del hotel  
- 🏨 Ocupación de habitaciones  
- 📉 Predicción de demanda  
- ⚙️ Planificación operativa  

### ❓ Pregunta clave:
**¿Qué factores aumentan o reducen la probabilidad de cancelación de una reserva?**

---

## 📊 Dataset

El dataset contiene información detallada sobre reservas hoteleras:

- Tipo de hotel (City Hotel / Resort Hotel)
- Fechas de reserva y lead time
- Características del cliente
- Canal de distribución
- Segmento de mercado
- Cambios en la reserva
- Solicitudes especiales
- ADR (Average Daily Rate)
- Estado final de la reserva

### 🎯 Variable objetivo:
- `is_canceled` → 1 = cancelada, 0 = no cancelada

---

## 🧠 Metodología

El análisis se estructuró en SQL siguiendo un enfoque EDA:

- Vista general del dataset  
- Análisis de distribución de cancelaciones  
- Segmentación por tipo de hotel  
- Análisis temporal (estacionalidad + lead time)  
- Segmentación de clientes  
- Análisis económico (ADR + depósitos)  
- Canales de adquisición  
- Comportamiento del cliente  
- Análisis combinado de variables  

---

## 📊 Insights Principales

### 📌 Tasa general de cancelación
En promedio, **1 de cada 3 reservas se cancela (37%)**.  
- City Hotel: **41,7%**  
- Resort Hotel: **27,8%**

---

### ⏳ Anticipación de la reserva (Lead Time)
- Principal factor de cancelación  
- +180 días → **57% cancelación**  
- <7 días → **9,6% cancelación**  
- Promedio canceladas: **145 días**  
- Promedio no canceladas: **80 días**

---

### 💳 Tipo de depósito
- “Non Refund” → **99,4% cancelación**

---

### 🌐 Canal de distribución
- Grupos → **61,1% cancelación**  
- Online TA → **36,7%**  
- Directas → **15,3%**

---

### 👤 Tipo de cliente
- Transitorios → **40,7%**  
- Grupos → **10,2%**

---

### 📅 Estacionalidad
- Mayor cancelación: verano y primavera  
- Menor cancelación: enero y noviembre  

---

### 🔁 Fidelidad del cliente
- Recurrentes → **14,5% cancelación**  
- Nuevos clientes → **37,8%**

---

### 🌍 País de origen
- Mayor volumen: Portugal (**27.519 cancelaciones**)  
- Mayor tasa:  
  - Angola → **56,6%**  
  - Portugal → **56,6%**  
  - China → **46,2%**  
  - Marruecos → **42,1%**  
  - España → **25,4%**

---

### ⭐ Solicitudes especiales
- 0 solicitudes → **47,7% cancelación**  
- 1 solicitud → **22%**  
- 5 solicitudes → **5%**

---

### 📉 Historial de cancelaciones
- Clientes con cancelaciones previas → **94,4% vuelven a cancelar**  
- ≥4 cancelaciones previas → **67,5% cancelación**

---

### 🅿️ Parking
- Solicitud de parking → **0% cancelación**

---

### 👨‍💼 Agentes
- Agente 9 → 41,5% cancelación  
- Agente 1 → 73% cancelación  
- Agente 29 → 79,9% cancelación  
- Agentes 236, 326, 31 → hasta **95–100% cancelación**

---

### 🍽️ Tipo de plan de comidas
- Full Board → **59,9%**  
- Half Board → **34,5%**

---

### 🔗 Combinaciones de riesgo
- City Hotel + Grupos → **68,9%**  
- City Hotel + Offline TA → **42,8%**  
- Resort Hotel + Directas → **13,5%**

---

### 🧩 Segmentos de comportamiento

- Reincidente → **91,6% cancelación**  
- Comprometido (parking) → **0%**  
- Huésped fiel → **3,1%**

---

## 🛠️ Herramientas Utilizadas

- MySQL  
- SQL (GROUP BY, CASE WHEN, subconsultas, agregaciones)  
- Dataset de Kaggle  

---

## 🚀 Conclusión

Este proyecto demuestra cómo **SQL puede utilizarse no solo para consultar datos, sino también para generar insights accionables de negocio**, permitiendo identificar patrones clave en cancelaciones hoteleras.

Los factores más influyentes fueron:

- ⏳ Anticipación de la reserva  
- 👤 Historial del cliente  
- 💳 Tipo de depósito  
- 🌐 Canal de distribución  
