def print_section_head(sec_head):
    print("\n", "\\section*{\"", sec_head, "\"}", sep = "")

def print_item_list(item_list):
    print("\t\\begin{itemize}")
    for item in item_list:
        print("\t\t", "\\item ", item, sep = "")
    print("\t\\end{itemize}")

def print_section_details(sec_head, item_list):
    print_section_head(sec_head)
    print_item_list(item_list)
    return()

def check_is_international(is_international):
    return(is_international)

def generate_edc(is_international):
    sec_head = "EDC"
    edc = ["pen (2)", "pocket notebook", "credit cards(2)", "ID"]
    
    if(is_international == 1):
        edc = edc + ["passport"]
    elif(is_international == 0):
        edc = edc

    print_section_details(sec_head, edc)

def generate_electronics(is_international):
    sec_head = "Electronics"
    electronics = ["USB-A to Thunderbolt", "laptop", "laptop charger", "charger phone", "iPad or handheld game", "powerbank"]
    if(is_international == 1):
        electronics = electronics + ["socket converter"]
    else:
        electronics = electronics

    print_section_head(sec_head)
    print_item_list(electronics)

def generate_toiletries():
    item_list = ["razor", "ibuprofen", "diphenhydramine", "glasses", "contacts", "contact fluid"]
    sec_head = "Toiletries"

    print_section_head(sec_head)
    print_item_list(item_list)

def generate_personal_effects():
    sec_head = "Personal Effects"

    personal_effects = ["haircut within 4 weeks", "empty water bottle", "contacted friends in city", "normal notebook", "reading book", "noise-cancelling headphones"]

    print_section_head(sec_head)
    print_item_list(personal_effects)

def generate_buy_list():
    sec_head = "Buy List"
    item_list = ["protein bars for flight OVER and BACK", "frozen meal ready at home for return"]

    print_section_head(sec_head)
    print_item_list(item_list)

def generate_tech_actions(is_international):
    sec_head = "Tech To-Dos Beforehand"
    item_list = ["SAVE phone number of airline customer service", "hotel app", "transit app"]

    if(is_international == 1):
        item_list = item_list + ["SAVE phone number and address for US embassy", "download eSIM"]
    else:
        item_list = item_list

    print_section_details(sec_head, item_list)

def generate_tex_header():
    # TODO: add typical LaTeX boilerplate
    print("\\documentclass{article}")
    print("\\usepackage[margin=1.00in]{geometry}")
    print("\\usepackage{titlesec,titling}")
    print("\\usepackage[utf8]{inputenc}")
    print("\\title{Packing List}")
    print("\\date{}")
    print("\\usepackage{hyperref}")
    print("\\hypersetup{colorlinks=true, urlcolor=blue, pdfpagemode=FullScreen}")

    print("\\begin{document}")
    print("\\maketitle")
    return()

def generate_tex_footer():
    print("\\end{document}")
    return()

def generate_tex_body():
    is_international = check_is_international(1)
    generate_tex_header()
    generate_buy_list()
    generate_edc(is_international)
    generate_personal_effects()
    generate_electronics(is_international)
    generate_toiletries()
    generate_tech_actions(is_international)
    return()

def create_document():
    generate_tex_header()
    generate_tex_body()
    generate_tex_footer()

create_document()
