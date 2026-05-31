import pandas as pd


class DataCleaner:
    """
    Utility class for cleaning and preprocessing regional Uzbekistan dataset.
    
    Methods
    -------
    clean(df)         : Standardizes column names, replaces missing values, drops empty rows/duplicates
    column_split(df)  : Splits 'region_year_id' composite key into separate 'region' and 'year' columns
    add_income_segment(df) : Adds Q1–Q4 income quartile segmentation column
    summary(df)       : Prints a brief data quality summary
    """

    def clean(self, df: pd.DataFrame) -> pd.DataFrame:
        """
        - Strips and lowercases column names
        - Replaces placeholder missing values ('..', 'N/A', '-', '') with pd.NA
        - Drops fully empty rows and duplicate rows
        """
        df = df.copy(deep=True)
        df.columns = (
            df.columns
            .str.strip()
            .str.lower()
            .str.replace(" ", "_", regex=False)
        )
        df.replace(["..", "N/A", "NA", "-", ""], pd.NA, inplace=True)
        df.dropna(how="all", inplace=True)
        df.drop_duplicates(inplace=True)
        return df

    def column_split(self, df: pd.DataFrame, column: str = "region_year_id") -> pd.DataFrame:
        """
        Splits composite key 'region_year_id' (e.g. 'Toshkentsh2024')
        into two separate columns: 'region' (category) and 'year' (int).
        """
        df = df.copy(deep=True)
        if column not in df.columns:
            print(f"[WARNING] Column '{column}' not found. Skipping split.")
            return df
        df[column] = df[column].astype(str)
        df["year"] = df[column].str[-4:].astype(int)
        df["region"] = df[column].str[:-4].astype("category")
        df.drop(columns=[column], inplace=True)
        return df

    def add_income_segment(self, df: pd.DataFrame, income_col: str = "income_pc") -> pd.DataFrame:
        """
        Adds 'income_segment' column: Q1 (lowest) to Q4 (highest)
        based on income_pc quartile within each year.
        """
        df = df.copy(deep=True)
        if income_col not in df.columns:
            print(f"[WARNING] Column '{income_col}' not found. Skipping segmentation.")
            return df
        df["income_segment"] = df.groupby("year")[income_col].transform(
            lambda x: pd.qcut(x, q=4, labels=["Q1", "Q2", "Q3", "Q4"], duplicates="drop")
        )
        return df

    def summary(self, df: pd.DataFrame) -> None:
        """
        Prints a quick data quality summary:
        shape, missing values per column, and dtypes.
        """
        print("=" * 50)
        print(f"Shape        : {df.shape[0]} rows × {df.shape[1]} columns")
        print(f"Duplicates   : {df.duplicated().sum()}")
        print(f"Missing vals : {df.isna().sum().sum()} total")
        print("-" * 50)
        missing = df.isna().sum()
        missing = missing[missing > 0]
        if len(missing) > 0:
            print("Columns with missing values:")
            print(missing.to_string())
        else:
            print("No missing values found ✓")
        print("=" * 50)
