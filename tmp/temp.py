import re


class Pconfig:
    # provider: str
    # path_key: str

    def __init__(self, provider, path_key):
        self.provider = provider
        self.path_key = path_key


pconfig = Pconfig("p", "k")

print(f"${{{pconfig.provider}:{pconfig.path_key}}}")

topic = "ORACLE_TFT_UO.TFT_UO.T_USER_EXTEND1"
topic_naming_pattern = r"(\w+)\.(\w+\.\w+)"
found = re.search(re.compile(topic_naming_pattern), topic)
print(found.group(2))
