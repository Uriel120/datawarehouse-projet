# **Convention de Nommage**  

Ce fichier fait office de convention de **nommage (nommination)** pour tout objet créé dans le projet.

## **Principe Général**

- **Convention à utiliser :** la convention de nommage utilisée dans ce projet est **snake_case** (mots en minuscules séparés par un underscore `_`).  
- **Langue utilisée :** le **français**.  
- **À éviter dans la nomination :** l’utilisation de **mots réservés SQL** est proscrite dans le nommage des tables.


## **Convention de Nommage des Tables**

### **Bronze Layer**

- Les noms des tables au niveau de la couche **Bronze** doivent suivre la nomenclature suivante :  
  `<<nomdusystemsource>>_<<entite>>`  
  - `<<nomdusystemsource>>` : représente le nom du système source (ex. `crm`, `ampl`).  
  - `<<entite>>` : représente le nom de la table elle-même dans le système source.  
- **Exemple :** `ampl_client` → table **client** provenant de la source **Amplitude**.

### **Silver Layer**

- Les noms des tables au niveau de la couche **Silver** suivent **la même nomenclature que la Bronze** :  
  `<<nomdusystemsource>>_<<entite>>`  
  - `<<nomdusystemsource>>` : nom du système source (ex. `crm`, `ampl`).  
  - `<<entite>>` : nom de la table dans le système source.  
- **Exemple :** `crm_commande` → table **commande** provenant du **CRM**.

### **Gold Layer**

- Les noms de tables au niveau **Gold** doivent être **significatifs** et alignés sur le domaine métier :  
  `<<category>>_<<entite>>`  
  - `<<category>>` : type de table créée (ex. `dim` pour dimension, `fact` pour table de faits).  
  - `<<entite>>` : nom aligné avec le domaine métier (ex. `products`, `clients`, `sales`).  

**Exemples :**  
- `dim_customers` : dimension représentant les données clients.  
- `fact_sales` : table de faits des ventes.

## **Glossaire des Patterns de Catégories**

| Pattern   | Signification             | Exemple(s)                                   |
|-----------|---------------------------|----------------------------------------------|
| `dim_`    | Table **Dimension**       | `dim_customer`, `dim_product`                |
| `fact_`   | Table **Fait**            | `fact_sales`                                 |
| `report_` | Table **Rapport**         | `report_customers`, `report_sales_monthly`   |


## **Convention de Nommage des Colonnes**

### **Clés de Substitution**

- Toutes les clés de substitution dans les tables doivent se terminer par le suffixe **`_key`** (ex. `<<tablename_key>>`).  
  - `tablename` : nom de la table à laquelle la clé appartient.  
  - `_key` : suffixe à ajouter au nom de la table.  

**Exemple :** `client_key` : clé de substitution pour la table **client**.


### **Stored Procedures**

- Toutes les procédures stockées utilisées pour le chargement doivent commencer par :  
  `<<action>>_<<couche>>`  
  - `<<action>>` :   
    - `load` pour un **chargement**,  
    - `process` pour un **traitement**,  
    - `extract` pour une **extraction**.  
  - `<<couche>>` : niveau de chargement dans la base de données (ex. `staging`, `bronze`, `silver`, `gold`, `raw_vault`, `business_vault`).  

**Exemple :** `load_bronze`
