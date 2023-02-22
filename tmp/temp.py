class Pconfig:
    # provider: str
    # path_key: str

    def __init__(self, provider, path_key):
        self.provider = provider
        self.path_key = path_key


pconfig = Pconfig("p", "k")

print(f"${{{pconfig.provider}:{pconfig.path_key}}}")
