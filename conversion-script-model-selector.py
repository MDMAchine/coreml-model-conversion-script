import os
import tkinter as tk

# Define the filename pattern and search keywords
filename_pattern = ['conversion-script-original-cus-res.sh', 'conversion-script-original.sh', 'conversion-script-split-einsum.sh']
keywords = ['orangemix', 'moistmixv2', 'raw', 'ema-vae-1.5', 'ema-vae-2.1', '256x256', '320x320', '384x384', '576x576', '256x384', '384x256', '320x576', '576x320', '512x768', '768x512', '768x768']

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
                            if enable:
                                file.write(line.lstrip('#'))
                            else:
                                file.write('#' + line.lstrip('#'))
                    else:
                        file.write(line)

# Define the main function
def main():
    root = tk.Tk()
    root.title("Model Selector")
    
    # Define the keyword listbox
    frame1 = tk.Frame(root)
    frame1.pack(side="left", fill="y")
    scrollbar = tk.Scrollbar(frame1, orient="vertical")
    listbox = tk.Listbox(frame1, yscrollcommand=scrollbar.set, height=20, width=30)
    scrollbar.config(command=listbox.yview)
    scrollbar.pack(side="right", fill="y")
    listbox.pack(side="left", fill="both", expand=True)
    for keyword in keywords:
        listbox.insert("end", keyword)

    # Define the buttons
    frame2 = tk.Frame(root)
    frame2.pack(side="left", fill="y")
    enable_button = tk.Button(frame2, text="Enable", command=lambda: toggle_lines(keywords[listbox.curselection()[0]], True, False) if listbox.curselection() else None)
    enable_button.pack(side="top", padx=5, pady=5)
    disable_button = tk.Button(frame2, text="Disable", command=lambda: toggle_lines(keywords[listbox.curselection()[0]], False, False) if listbox.curselection() else None)
    disable_button.pack(side="top", padx=5, pady=5)
    enable_all_button = tk.Button(frame2, text="Enable All", command=lambda: toggle_lines(None, True, True))
    enable_all_button.pack(side="top", padx=5, pady=5)
    disable_all_button = tk.Button(frame2, text="Disable All", command=lambda: toggle_lines(None, False, False))
    disable_all_button.pack(side="top", padx=5, pady=5)

    root.mainloop()

if __name__ == '__main__':
    main()