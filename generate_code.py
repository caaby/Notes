import random


def generate_code(code_len = 4):
    """
    验证码生成器,默认生成4位验证码
    :param code_len:
    :return:
    """
    all_chars = "1234567890qwertyuiopasdfghjklzxcvbnm"
    len_index= len(all_chars) - 1
    code = ""
    for _ in range(code_len):
        index = random.randint(0,len_index)
        code += all_chars[index]
    return code
p = generate_code(5)
print(p)