from PIL import Image
import sys
import os

def convert_to_transparent(image_path):
    try:
        img = Image.open(image_path)
        img = img.convert("RGBA")
        
        datas = img.getdata()
        
        newData = []
        # Tolerance for "white"
        threshold = 240
        
        for item in datas:
            if item[0] > threshold and item[1] > threshold and item[2] > threshold:
                newData.append((255, 255, 255, 0))
            else:
                newData.append(item)
        
        img.putdata(newData)
        
        # Save overwriting the original
        img.save(image_path, "PNG")
        print(f"Converted {image_path}")
    except Exception as e:
        print(f"Error converting {image_path}: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python convert_to_transparent.py <image_path>")
        sys.exit(1)
    
    for arg in sys.argv[1:]:
        convert_to_transparent(arg)
