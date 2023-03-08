import os

# Define the filename pattern
filename_pattern = [
    'conversion-script-original-cus-res.sh',
    'conversion-script-original.sh',
    'conversion-script-split-einsum.sh'
]

# Define the search keywords
keywords = [
    'orangemix',
    'moistmixv2',
    'raw',
    'ema-vae-1.5',
    'ema-vae-2.1',
    '256x256',
    '320x320',
    '384x384',
    '576x576',
    '256x384',
    '384x256',
    '320x576',
    '576x320',
    '512x768',
    '768x512',
    '768x768'
]

# Define the function to enable/disable conversion_model lines
def toggle_lines(keyword, enable, enable_all):
    for filename in os.listdir('.'):
        if filename.startswith(tuple(filename_pattern)) and filename.endswith('.sh'):
            with open(filename, 'r') as file:
                content = file.readlines()
            with open(filename, 'w') as file:
                for line in content:
                    if line.startswith('# Convert each model using the convert_model function') or line.startswith('function convert_model() {'):
                        # Skip this line
                        file.write(line)
                        continue
                    if keyword is None:
                        if 'convert_model' in line:
                            if enable_all:
                                file.write(line.lstrip('#'))
                            else:
                                file.write('#' + line)
                        else:
                            file.write(line)
                    elif 'convert_model' in line and keyword in line:
                        if '#' in line and enable:
                            print(f'Enabling line: {line.strip()}')
                        elif not '#' in line and not enable:
                            print(f'Disabling line: {line.strip()}')
                        if enable_all:
                            file.write(line.lstrip('#'))
                        else:
                            file.write(line.lstrip('#') if enable else '#' + line)
                    else:
                        file.write(line)


# Define the main function
def main():
    menu = {
        '1': 'orangemix-vae',
        '2': 'moistmixv2-vae',
        '3': 'raw',
        '4': 'ema-vae-1.5',
        '5': 'ema-vae-2.1',
        '6': '256x256',
        '7': '320x320',
        '8': '384x384',
        '9': '576x576',
        '10': '768x768',
        '11': '256x384',
        '12': '384x256',
        '13': '320x576',
        '14': '576x320',
        '15': '512x768',
        '16': '768x512',
    }
    exit_loop = False
    while not exit_loop:
        print('Choose an option:')
        for key, value in menu.items():
            print(f'{key}. Toggle convert_model lines with keyword "{value}"')
        print('17. Enable all conversion_model lines')
        print('18. Disable all conversion_model lines')
        print('19. Exit this script')
        choice = input('Enter your choice: ')
        if choice in menu:
            enable = input('Enable or disable? y=on n=off (y/n): ')
            toggle_lines(menu[choice], enable.lower() == 'y', False)
        elif choice == '17':
            toggle_lines(None, None, True)
        elif choice == '18':
            toggle_lines(None, None, False)
        elif choice == '19':
            exit_loop = True


if __name__ == '__main__':
    main()
