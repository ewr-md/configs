import csv
import os
import time

def download_videos():
    file_to_open = 'dl.csv'
    count_csv_rows(file_to_open)

    with open(file_to_open) as file:
        cli_program = 'yt-dlp'
        reader_obj = csv.reader(file)
        for row in file:
            os.system(f'{cli_program} {row}')


def count_csv_rows(filename):
    with open(filename) as f:
        num_lines = sum(1 for line in f)
        print(f'Number of files:\t{num_lines}')


def main():
    start_time = time.time()
    download_videos()
    minutes = time.time()-start_time // 60
    seconds = time.time()-start_time % 60
    print(f'Time taken:\t{minutes} min {seconds} sec')

if __name__=='__main__':
    main()
