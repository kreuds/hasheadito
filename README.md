
**Verificador de hashes SHA256 para archivos PDF**  
Con estética retro estilo terminal 386 / 486.

---

## 🧠 ¿Qué hace?

HASEADITO permite verificar la integridad de múltiples archivos PDF comparando sus hashes SHA256 contra una lista.

✔ No requiere cargar nombres de archivos  
✔ Funciona automáticamente sobre carpetas  
✔ Genera reportes en CSV y HTML  
✔ Interfaz visual estilo old school

---

## ⚙️ Cómo funciona

1. Recorre todos los `.pdf` dentro de la carpeta `PDF`
2. Calcula el hash **SHA256** de cada archivo
3. Lee todos los hashes desde `HASHES/hashes.txt`
4. Compara cada PDF contra esa lista
5. Marca:
   - ✔ `MATCH` → si el hash existe en la lista
   - ✘ `NOT MATCH` → si no existe

---

## 📁 Estructura del proyecto

```text
hasheadito/
│   hasheadito.ps1
├───PDF/
│      archivo1.pdf
│      archivo2.pdf
└───HASHES/
       hashes.txt


▶️ Cómo usar HASEADITO
1. Descargar el proyecto

Desde GitHub:

Botón Code → Download ZIP
Descomprimir en una carpeta
2. Preparar archivos
Copiar los PDFs dentro de la carpeta PDF
Colocar los hashes en HASHES/hashes.txt
3. Ejecutar

Abrir PowerShell en la carpeta del proyecto y ejecutar:

.\hasheadito.ps1

📊 Archivos generados

Después de ejecutar, se crean:

hasheadito_resultado.csv → resultados detallados
hasheadito_resultado.html → reporte visual (verde/rojo)
hasheadito_hashes_sin_coincidencia.txt → hashes no utilizados
⚠️ Problema común: Execution Policy

Si aparece este error:

No se puede cargar el archivo ... porque la ejecución de scripts está deshabilitada en este sistema
Solución (temporal)

Ejecutar:

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

Luego volver a ejecutar:

.\hasheadito.ps1
📌 Requisitos
Windows
PowerShell
Archivos PDF
Hashes SHA256 válidos
🧠 Consideraciones
No importa el nombre del archivo
No importa el orden
Solo importa el hash
Un archivo es válido si su hash está en la lista

