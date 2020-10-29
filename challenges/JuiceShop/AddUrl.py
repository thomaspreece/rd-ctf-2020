import yaml

output_items = []
filtered_output_items = []

filter = [
    "Error Handling",
    "Login Admin",
    # "Login Bender",
    "Login Jim",
    "Christmas Special",
    "Zero Stars",
    # "Admin Registration",
    "Payback Time",
    "Deluxe Fraud",
    "DOM XSS",
    "Database Schema",
    "User Credentials",
    "NoSQL Manipulation",
    "View Basket",
    "Manipulate Basket",
    "Forged Feedback",
    "Forged Review"
    "Forgotten Developer Backup",
    # "Forgotten Sales Backup",
    "Easter Egg",
    "Login Amy"
]

with open('Initial_JuiceShop_Export.yaml') as file:
    # The FullLoader parameter handles the conversion from YAML
    # scalar values to Python the dictionary format
    items = yaml.load_all(file, Loader=yaml.FullLoader)

    for item in items:
        item["description"] = item["description"] + "<br/><br/>Try it out at https://juiceshop.training.bbc-security-champions.com/"
        name = item["name"]
        item["name"] = item["name"] + " (JuiceShop)"
        item["hints"][1]["cost"] = 0
        output_items.append(item)
        if name in filter:
            filtered_output_items.append(item)

with open('JuiceShop_Export.yaml', "w") as file:
    yaml.dump_all(
        output_items,
        file,
        default_flow_style=False
    )

with open('JuiceShop_Filtered.yaml', "w") as file:
    yaml.dump_all(
        filtered_output_items,
        file,
        default_flow_style=False
    )
