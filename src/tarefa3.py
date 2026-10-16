import pandas as pd

# 1. Lista con los nombres de tus 3 archivos CSV
archivos = ["datos/raw/vendas_2025_cuadrimestre1.csv",
            "datos/raw/vendas_2025_cuadrimestre2.csv",
            "datos/raw/vendas_2025_cuadrimestre3.csv"]

# Lista para guardar los DataFrames cargados
lista_dfs = []

print("--- RESULTADOS POR CUATRIMESTRE ---")

# 2. Leer y calcular cada cuatrimestre
for i, archivo in enumerate(archivos, start=1):
    # Leer CSV
    df = pd.read_csv(archivo, sep=";", decimal=",")

    # Eliminar ventas repetidas dentro de cada archivo
    df = df.drop_duplicates(subset="id_venda")

    # Asegurar conversión a número
    df["importe"] = pd.to_numeric(df["importe"], errors="coerce").fillna(0)

    df["periodo"] = i
    # Guardar en la lista para el cálculo global
    lista_dfs.append(df)

# 3. Unir los 3 CSVs y eliminar ventas repetidas entre archivos
df_total = pd.concat(lista_dfs, ignore_index=True).drop_duplicates(subset="id_venda")

resultados = []
for i in range(1, len(archivos) + 1):
    df_periodo = df_total[df_total["periodo"] == i]
    dinero_periodo = df_periodo["importe"].sum()
    ventas_periodo = len(df_periodo)
    resultados.append({"periodo": f"Cuatrimestre {i}", "importe": round(dinero_periodo, 2), "ventas": ventas_periodo})
    print(f"Cuatrimestre {i}: {dinero_periodo:.2f} € | {ventas_periodo} ventas")

total_dinero_global = df_total["importe"].sum()
total_ventas_global = len(df_total)

print("\n--- TOTAL ACUMULADO (3 CUATRIMESTRES) ---")
print(f"Total de dinero recaudado: {total_dinero_global:.2f} €")
print(f"Cantidad total de ventas:  {total_ventas_global}")

# 4. Guardar los resultados en la carpeta output
resultados.append({"periodo": "Total 2025", "importe": round(total_dinero_global, 2), "ventas": total_ventas_global})
pd.DataFrame(resultados).to_csv("output/resultados_tarefa3.csv", sep=";", decimal=",", index=False)
