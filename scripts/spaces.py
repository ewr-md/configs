import os
import time

def get_file_list():
    visible_files = [file for file in os.listdir('.') if not file.startswith('.')]
    return visible_files

def replace(string):
    [os.rename(file, file.replace(string, '_')) for file in get_file_list()]

def make_lower():
    [os.rename(file, file.lower()) for file in get_file_list()]

def main():
    start_time = time.time()

    number_of_files = len(get_file_list())
    replace_list = (' ', '-', ',', '_', '?', '!', '[', ']', '__')

    [replace(items) for items in replace_list]
    make_lower()

    print(f'Files modified:\t{number_of_files}')
    print("Time taken:\t%.3e seconds" % (time.time() - start_time))


if __name__ == '__main__':
    main()
