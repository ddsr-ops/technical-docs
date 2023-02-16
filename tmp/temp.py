from typing import Tuple, List


def get_table_names(self) -> List[Tuple]:
    sep: str = "."
    leading_quote_char: str = '"'
    trailing_quote_char: str = leading_quote_char

    table_ids: List[str] = []
    if self.connector_manifest.tasks:
        table_ids = (
            ",".join(
                [
                    task["config"].get("tables")
                    for task in self.connector_manifest.tasks
                ]
            )
        ).split(",")
        quote_method = self.connector_manifest.config.get(
            "quote.sql.identifiers", "always"
        )
        if (
                quote_method == "always"
                and table_ids
                and table_ids[0]
                and table_ids[-1]
        ):
            leading_quote_char = table_ids[0][0]
            trailing_quote_char = table_ids[-1][-1]
            # This will only work for single character quotes
    elif self.connector_manifest.config.get("table.whitelist"):
        table_ids = self.connector_manifest.config.get("table.whitelist").split(",")  # type: ignore

    # List of Tuple containing (schema, table)
    tables: List[Tuple] = [
        (
            unquote(
                table_id.split(sep)[-2], leading_quote_char, trailing_quote_char
            )
            if len(table_id.split(sep)) > 1
            else "",
            unquote(
                table_id.split(sep)[-1], leading_quote_char, trailing_quote_char
            ),
        )
        for table_id in table_ids
    ]
    return tables