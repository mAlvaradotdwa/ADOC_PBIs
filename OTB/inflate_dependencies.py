#%%
import pandas as pd
relations = [
    [ "Fecha" , "" ] ,
    [ "UltimaFecha OTB" , "" ] ,
    [ "Reservas L1" , "Adelantos L1, Equivalentes, Jerarquía Base" ] ,
    [ "Equivalentes" , "" ] ,
    [ "Adelantos L1" , "" ] ,
    [ "LAP Planner 2" , "" ] ,
    [ "LAP Planner 3" , "" ] ,
    [ "LAP Planner 4" , "" ] ,
    [ "Base L1" , "" ] ,
    [ "Arribos Planner 1" , "Agrupacion_Marcas" ] ,
    [ "Arribos Planner 2" , "Agrupacion_Marcas" ] ,
    [ "Arribos Planner 3" , "Agrupacion_Marcas" ] ,
    [ "Arribos Planner 4" , "Agrupacion_Marcas" ] ,
    [ "LAP ADOC" , "Agrupacion_Marcas" ] ,
    [ "LAP PAR2" , "Agrupacion_Marcas" ] ,
    [ "LAP INTER" , "Agrupacion_Marcas" ] ,
    [ "Arribos ADOC" , "Agrupacion_Marcas" ] ,
    [ "Arribos PAR2" , "Agrupacion_Marcas" ] ,
    [ "Arribos INTER" , "Agrupacion_Marcas" ] ,
    [ "LAP Base" , "LAP Planner 1, LAP Planner 2, LAP Planner 3, LAP Planner 4, Base L1" ] ,
    [ "Arribos Ajustados" , "Arribos Planner 1, Arribos Planner 2, Arribos Planner 3, Arribos Planner 4, Jerarquía Base" ] ,
    [ "LAP" , "LAP PAR2, LAP INTER, LAP ADOC" ] ,
    [ "Plan Final" , "Base Planes" ] ,
    [ "Base Planes" , "" ] ,
    [ "ALMACENES" , "" ] ,
    [ "EKPO import" , "ALMACENES, Agrupacion_Marcas" ] ,
    [ "Jerarquía Base" , "Agrupacion_Marcas, LAP Base" ] ,
    [ "Agrupacion_Marcas" , "" ] ,
    [ "Inventario TGT NOS" , "Agrupacion_Marcas" ] ,
    [ "DatosArticulos" , "" ] ,
    [ "tbl_qryCGN" , "" ] ,
    [ "1. Medidas" , "" ] ,
    [ "Actualización" , "" ] ,
    [ "Arribos" , "Agrupacion_Marcas, Arribos Ajustados" ] ,
    [ "Arribos sql original" , "" ] ,
    [ "ArticuloProveedor" , "" ] ,
    [ "BaseTipoPlanes" , "" ] ,
    [ "Calendario" , "" ] ,
    [ "fact_comercial_consolidado" , "" ] ,
    [ "Inventario TGT" , "Agrupacion_Marcas, Inventario TGT NOS" ] ,
    [ "LAP NOS" , "LAP Planner 1, LAP Planner 2, LAP Planner 3, LAP Planner 4, LAP Open" ] ,
    [ "LAP Open" , "Agrupacion_Marcas" ] ,
    [ "LAP Planner 1" , "" ] ,
    [ "OTB" , "Arribos, Plan Final, Reservas L1, Arribos ADOC, Arribos PAR2, Arribos INTER, LAP, Inventario TGT, LAP NOS, Agrupacion_Marcas, EKPO import" ] ,
    [ "OTB Max Fecha" , "UltimaFecha OTB" ] ,
    [ "Plan Max Año" , "Plan Final" ] ,
    [ "Planes" , "Base Planes" ] ,
    [ "Proveedores" , "" ] ,
    [ "Tipo OTB" , "" ] 
]

dependencies = []
for i in relations:
    if i[1] != '':
        for d in i[1].split(','):
            dependencies.append([i[0],d])

df = pd.DataFrame ( dependencies , columns=["object","dependency"])

# print(df.head())

df.to_csv("dependencies.csv", encoding="utf-8", index=False, sep='\t')