import pandas as pd
import unicodedata
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import confusion_matrix, classification_report, accuracy_score

# ---------------------------------------------
# Normalización de texto (sin acentos, minúsculas)
# ---------------------------------------------
def normalize_text(s):
    if pd.isna(s):
        return s
    s = str(s).strip().lower()
    s = unicodedata.normalize('NFKD', s).encode('ASCII', 'ignore').decode('ASCII')
    return s

# ---------------------------------------------
# Cargar el dataset original
# ---------------------------------------------
df = pd.read_csv("../hongos.csv")  # ajustar nombre si es necesario

# Selección de columnas usadas en el proyecto
df = df[['Forma_sombrero', 'Olor', 'Habitat', 'Clase']].dropna()

# Normalizar texto
for c in ['Forma_sombrero', 'Olor', 'Habitat', 'Clase']:
    df[c] = df[c].apply(normalize_text)

# ---------------------------------------------
# Preparación de variables
# ---------------------------------------------
X = df[['Forma_sombrero', 'Olor', 'Habitat']]
y = df['Clase'].map({'ingerible': 0, 'venenoso': 1})

# Codificación one-hot
X_encoded = pd.get_dummies(X)

# División entrenamiento / test
X_train, X_test, y_train, y_test = train_test_split(
    X_encoded, y,
    test_size=0.20,
    random_state=42,
    stratify=y
)

# ---------------------------------------------
# Entrenamiento del árbol de decisión
# ---------------------------------------------
tree = DecisionTreeClassifier(random_state=42, min_samples_leaf=1)
tree.fit(X_train, y_train)

# Predicción sobre test
y_pred = tree.predict(X_test)

# ---------------------------------------------
# Matriz de confusión y métricas
# ---------------------------------------------
cm = confusion_matrix(y_test, y_pred)
acc = accuracy_score(y_test, y_pred)
report = classification_report(y_test, y_pred)

# Reemplaza las impresiones directas por escritura a archivo (y mantiene impresión en consola)
archivo = "matriz_confusion_reporte.txt"

# Formatear la matriz de confusión como tabla con etiquetas
labels = ['ingerible', 'venenoso']
try:
	df_cm = pd.DataFrame(cm, index=labels, columns=labels)
	cm_text = df_cm.to_string()
except Exception:
	# fallback simple si hay algún problema formateando
	cm_text = str(cm)

with open(archivo, "w", encoding="utf-8") as f:
	f.write("=== Matriz de Confusión ===\n")
	f.write(cm_text + "\n\n")
	f.write("=== Accuracy ===\n")
	f.write(f"{acc}\n\n")
	f.write("=== Classification Report ===\n")
	f.write(report + "\n")

# Impresiones en consola (opcional)
print("=== Matriz de Confusión ===")
print(cm_text)

print("\n=== Accuracy ===")
print(acc)

print("\n=== Classification Report ===")
print(report)

print(f"\nReporte guardado en: {archivo}")
