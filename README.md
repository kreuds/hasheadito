
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
