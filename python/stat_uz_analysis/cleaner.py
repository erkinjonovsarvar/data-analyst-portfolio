import pandas as pd
from sympy.integrals.meijerint_doc import category


class DataCleaner:
    def clean(self, df):
        df = df.copy(deep=True)
        df.columns = (
            df.columns
              .str.strip()
              .str.lower()
              .str.replace(" ", "_")
        )
        df.replace(["..", "N/A", "NA", "-", ""], pd.NA, inplace=True)
        df.dropna(how="all", inplace=True)
        df.drop_duplicates(inplace=True)
        return df
    def column_split(self, df, column = "region_year_id"):
        df = df.copy(deep=True)
        if column not in df.columns:
            return df
        df[column] = df[column].astype(str)
        df["year"] = df[column].str[-4:].astype(int)
        df["region"] = df[column].str[:-4].astype("category")
        df.drop(columns=[column], inplace=True)
        return df