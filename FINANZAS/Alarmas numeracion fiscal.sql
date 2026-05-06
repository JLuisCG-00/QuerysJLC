SELECT
    T0."DocEntry",
    T0."U_TDF" AS "Tipo de documento",
    T0."U_SeriesName" AS "Nombre serie",
    T0."U_CAI" AS "CAI",
    T0."U_FLE" AS "Fecha límite de emisión",
    T0."U_PRE" AS "Prefijo",
    T0."U_INI" AS "Número inicial",
    T0."U_ACT" AS "Número actual",
    T0."U_FIN" AS "Número final",
    T0."U_FIN" - T0."U_ACT" AS "Número de documentos disponibles",
    DATEDIFF(day, GETDATE(),T0."U_FLE") AS "Días restantes"
FROM "@NFI" T0
WHERE (T0."U_FIN" - T0."U_ACT") <= T0."U_DPN" 
    OR DATEDIFF(day, GETDATE(),T0."U_FLE") <= T0."U_CPN"