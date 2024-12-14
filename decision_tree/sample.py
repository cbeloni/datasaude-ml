import pandas as pd
from sklearn.datasets import load_iris
from sklearn.tree import DecisionTreeClassifier, export_text
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

# Carregar o dataset Iris
iris = load_iris()
data = pd.DataFrame(data=iris.data, columns=iris.feature_names)
data["target"] = iris.target

# Dividir o dataset em treino e teste
X = data.iloc[:, :-1]  # Features
y = data["target"]      # Target
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

# Criar e treinar a árvore de decisão
tree = DecisionTreeClassifier(random_state=42)
tree.fit(X_train, y_train)

# Fazer previsões
y_pred = tree.predict(X_test)

# Avaliar o modelo
accuracy = accuracy_score(y_test, y_pred)
print(f"Accuracy: {accuracy:.2f}")

# Visualizar a árvore de decisão
tree_rules = export_text(tree, feature_names=list(X.columns))
print("\nRegras da árvore de decisão:")
print(tree_rules)
