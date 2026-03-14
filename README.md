# microfinance-credit-risk-dashboard
Credit risk dashboard para una cartera de microfinanzas mediante SQL Server y Power BI con análisis de cohortes.
Credit Risk Dashboard – Microfinance Portfolio

Este proyecto desarrolla un dashboard de análisis de riesgo crediticio utilizando SQL Server y Power BI.

El objetivo es monitorear la calidad de la cartera de una institución microfinanciera, identificando:

niveles de morosidad

segmentos de mayor riesgo

comportamiento de pago de los créditos a lo largo del tiempo

El análisis utiliza Vintage Analysis (análisis de cohortes), una técnica común en gestión de riesgo crediticio utilizada por bancos y fintech.

🎯 Objetivos del proyecto

El proyecto busca responder preguntas clave de gestión de cartera:

¿Cuál es el nivel actual de morosidad del portafolio?

¿Qué productos presentan mayor riesgo?

¿Existen diferencias geográficas en la mora?

¿Qué asesores tienen carteras más riesgosas?

¿Cómo evoluciona la mora desde el desembolso del crédito?

🗄 Data Pipeline (SQL Layer)

Antes de construir el dashboard en Power BI se desarrolló una capa analítica en SQL Server para transformar los datos operativos en una estructura orientada al análisis de riesgo.

1️⃣ Exploración inicial de la base de datos

Se realizó una revisión inicial para validar la calidad y cobertura del dataset.

Se verificaron:

número de clientes

número de créditos

número de cuotas

número de pagos

rango temporal de desembolsos

distribución de estados de cuotas

Esto permitió confirmar que la base era adecuada para realizar un análisis de morosidad y cohortes.

2️⃣ Construcción de la base analítica vintage

Se creó una estructura analítica enfocada en el análisis temporal del crédito.

Se desarrollaron dos vistas principales.

base_vintage

Integra la información de créditos y cuotas, donde cada fila representa una cuota de un crédito.

Variables principales:

Variable	Descripción
cohorte_desembolso	mes de originación del crédito
loan_age	edad del crédito en meses
monto_total	valor de la cuota
estado	estado de pago

También se generaron variables binarias:

flag_mora

flag_pagado

flag_pendiente

Estas variables permiten calcular indicadores de cartera y construir el análisis vintage.

base_vintage_detalle

Esta vista amplía la base analítica incorporando dimensiones de negocio.

Incluye variables como:

Dimensión	Variables
Producto	tipo de crédito
Ubicación	agencia, zona, región
Asesor	ejecutivo de crédito
Cliente	género, ingreso mensual

Esto permite realizar análisis multidimensional del riesgo.

3️⃣ Construcción del resumen vintage

Se creó una vista agregada llamada:

vintage_resumen


Esta vista resume la información por:

cohorte de desembolso

edad del crédito (loan_age)

Cada fila representa:

cohorte_desembolso + loan_age


Se calculan métricas como:

número de créditos

monto total de cuotas

monto vencido

cuotas vencidas

También se generan indicadores clave:

porcentaje de monto vencido

porcentaje de cuotas vencidas

Esto permite analizar cómo evoluciona la mora a lo largo del ciclo de vida del crédito.

4️⃣ Cálculo de KPIs de cartera

A partir de la base analítica se calcularon indicadores de riesgo utilizados en el dashboard.

Principales KPIs:

KPI	Descripción
Cartera total	exposición total del portafolio
Monto vencido	valor de cuotas en mora
% monto vencido	proporción monetaria de la mora
% cuotas vencidas	frecuencia de incumplimiento
% créditos con mora	créditos con al menos una cuota vencida

También se realizaron cortes analíticos por:

producto financiero

zona geográfica

asesor de crédito

Esto permite identificar concentraciones de riesgo dentro del portafolio.

5️⃣ Vistas analíticas para Power BI

Se crearon vistas optimizadas para visualización en Power BI.

Vista	Propósito
pbi_vintage_matrix	matriz vintage
pbi_mora_producto	mora por producto
pbi_mora_zona	mora geográfica
pbi_mora_asesor	mora por asesor
pbi_mora_cohorte	mora por cohorte

Estas vistas separan:

capa analítica (SQL)
de
capa de visualización (Power BI).

📊 Dashboard
Executive Dashboard

Esta página muestra el estado general de la cartera mediante indicadores clave.

Principales métricas del portafolio:

KPI	Valor
Cartera total	3,100,675
Monto vencido	152,937
% monto vencido	4.93%
% cuotas vencidas	5.12%
% créditos en mora	6.40%

También incluye análisis de mora por:

producto

zona

asesor

📉 Vintage Analysis

El análisis de cohortes permite estudiar cómo evoluciona la mora desde el momento en que se desembolsa el crédito.

Matriz Vintage

La matriz organiza los créditos según:

Filas

cohorte_desembolso


Columnas

loan_age


Valores

pct_monto_vencido


Esto permite observar cómo se deteriora cada cohorte con el paso del tiempo.

Curvas de Cohortes

El gráfico de líneas muestra la evolución de la mora a medida que el crédito envejece.

Cada línea representa una cohorte distinta.

Este análisis permite identificar:

velocidad de deterioro del crédito

diferencias entre cohortes

estabilidad de la originación de créditos

🧠 Principales insights

El análisis del dashboard permite identificar:

El 4.93% del monto de la cartera se encuentra vencido.

El 6.40% de los créditos presenta al menos una cuota en mora.

La zona Sur presenta el mayor nivel de morosidad.

Algunos productos muestran mayor concentración de riesgo.

📉 Recomendaciones de gestión de riesgo

A partir del análisis se sugieren las siguientes acciones:

reforzar la evaluación crediticia en zonas con mayor mora

monitorear el desempeño de asesores con mayor deterioro de cartera

revisar condiciones de productos con mayor riesgo

implementar alertas tempranas para créditos con atrasos iniciales

Estas medidas pueden ayudar a reducir la mora y mejorar la calidad de la cartera.

🛠 Herramientas utilizadas

SQL Server

Power BI

Data Modeling

Vintage Analysis

💼 Valor del proyecto

Este proyecto simula un caso real de análisis de riesgo crediticio, integrando:

modelado de datos en SQL

construcción de indicadores financieros

análisis de cohortes

visualización ejecutiva en Power BI

El enfoque busca replicar el tipo de análisis realizado por analistas de riesgo en bancos, fintech y entidades microfinancieras.
