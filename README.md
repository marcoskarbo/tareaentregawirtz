# Tarea 3 - Ventas 2025 en varios CSV

Marcos Rozas Castro y Roberto Grille Boga

En esta tarea los datos de 2025 vienen separados en 3 ficheros, uno por cuatrimestre. Hay que calcular el dinero total y el número de ventas del año (y de paso sacamos también el de cada cuatrimestre).

El cuatrimestre 2 tiene ventas repetidas, así que se quitan con `drop_duplicates` usando `id_venda`.

## Resultados

| Periodo | Importe (€) | Ventas |
|---|---|---|
| Cuatrimestre 1 | 376.953.315,26 | 1.150.000 |
| Cuatrimestre 2 | 377.239.286,98 | 1.150.000 |
| Cuatrimestre 3 | 377.546.079,10 | 1.150.000 |
| **Total 2025** | **1.131.738.681,34** | **3.450.000** |

## Carpetas

- `datos/raw/` - los CSV
- `src/tarefa3.py` - el script
- `sql/tarefa3.sql` - el mismo cálculo en MySQL
- `output/` - el CSV con los resultados y el informe en PDF

## Cómo ejecutarlo

Lo hicimos desde WSL (Ubuntu):

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

python src/tarefa3.py
```

Con MySQL en Docker:

```bash
docker compose up -d
docker exec mysql-vendas sh -c 'mysql -uroot -pbigdata vendas < /sql/tarefa3.sql'
docker compose down
```
