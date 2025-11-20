import pandas as pd
from sklearn.tree import DecisionTreeClassifier, export_text

# Cargar los datos
df = pd.read_csv("../hongos.csv")  # o "hongos.xls"

# Seleccionar columnas
df = df[['Forma_sombrero', 'Olor', 'Habitat', 'Clase']].dropna()

# Separar variables
X = df[['Forma_sombrero', 'Olor', 'Habitat']]
y = df['Clase']

# Codificar variables categóricas
X_encoded = pd.get_dummies(X)
y_encoded = y.map({'ingerible': 0, 'venenoso': 1})  # ajusta según tus etiquetas

# Entrenar árbol completo sin límite de profundidad
tree = DecisionTreeClassifier(random_state=42, min_samples_leaf=1)
tree.fit(X_encoded, y_encoded)

# Exportar todas las reglas
reglas = export_text(tree, feature_names=X_encoded.columns.tolist(), decimals=3, show_weights=True)

# Guardar reglas en un archivo .txt (reemplaza impresión directa)
archivo = "arbol_decision_reglas.txt"
with open(archivo, "w", encoding="utf-8") as f:
	f.write("=== Reglas obtenidas ===\n")
	f.write(reglas)

print(f"Reglas guardadas en: {archivo}")
