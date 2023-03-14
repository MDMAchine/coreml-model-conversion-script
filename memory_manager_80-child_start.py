import subprocess
import resource
import platform
import sys
import tkinter as tk
from PIL import Image, ImageTk
import io
import requests
import random
import psutil

def memory_limit():
    """
    Only works on macOS operating systems
    """
    if platform.system() != "Darwin":
        print("Memory limit not supported on this platform!")
        return

    total_mem = psutil.virtual_memory().total
    limit = int(0.8 * total_mem)
    current_limit_as = resource.getrlimit(resource.RLIMIT_AS)[0]

    if current_limit_as < limit:
        subprocess.run(["launchctl", "limit", "maxrss", str(limit), str(limit)])
#         subprocess.run(["launchctl", "limit", "maxswap", str(limit), str(limit)])
        resource.setrlimit(resource.RLIMIT_AS, (limit, limit))

def memory(function):
    def wrapper(*args, **kwargs):
        memory_limit()
        try:
            return function(*args, **kwargs)
        except MemoryError:
            print("Memory limit exceeded!")
            sys.exit(1)
    return wrapper

@memory
def run_script(label, root):
    try:
        subprocess.check_call(["./conversion-script-selector.sh"])
    except subprocess.CalledProcessError as e:
        print(f"Error running script: {e}")
        sys.exit(1)

    # Update label text and destroy the window
    label.config(text="Script terminating.", fg="red")
    root.after(2000, root.destroy)

def main():
    # Create a window with a canvas and a label widget
    root = tk.Tk()
    root.geometry("432x240")
    root.title("80% Mem Mode")  # Set the window title
    canvas = tk.Canvas(root, width=432, height=240)
    canvas.pack()
    label = tk.Label(root, text="Running low memory mode...\n80% Method\nUse option 16 in menu to terminate.", fg="yellow", font=("Arial", 12))
    label.place(relx=0.5, rely=0.1, anchor="n")

    # Download a random image from the web directory
    image_links = [
       "https://raw.githubusercontent.com/MDMAchine/coreml-model-conversion-script/main/misc/images/loading_img_1.png",
        "https://raw.githubusercontent.com/MDMAchine/coreml-model-conversion-script/main/misc/images/loading_img_2.png",
        "https://raw.githubusercontent.com/MDMAchine/coreml-model-conversion-script/main/misc/images/loading_img_3.png",
        "https://raw.githubusercontent.com/MDMAchine/coreml-model-conversion-script/main/misc/images/loading_img_4.png",
        "https://raw.githubusercontent.com/MDMAchine/coreml-model-conversion-script/main/misc/images/loading_img_5.png",
        "https://raw.githubusercontent.com/MDMAchine/coreml-model-conversion-script/main/misc/images/loading_img_6.png",
        "https://raw.githubusercontent.com/MDMAchine/coreml-model-conversion-script/main/misc/images/loading_img_7.png",
        "https://raw.githubusercontent.com/MDMAchine/coreml-model-conversion-script/main/misc/images/loading_img_8.png",
        "https://raw.githubusercontent.com/MDMAchine/coreml-model-conversion-script/main/misc/images/loading_img_9.png",
        "https://raw.githubusercontent.com/MDMAchine/coreml-model-conversion-script/main/misc/images/loading_img_10.png",
    ]
    image_url = random.choice(image_links)
    response = requests.get(image_url)
    img = Image.open(io.BytesIO(response.content))
    img = img.resize((432, 240), Image.LANCZOS)
    photo = ImageTk.PhotoImage(img)
    canvas.create_image(0, 0, anchor="nw", image=photo)

    # Update the window
    root.update()

    # Run the script
    run_script(label, root)

    # Start the mainloop
    root.mainloop()

if __name__ == "__main__":
    main()
