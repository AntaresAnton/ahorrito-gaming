import os
import time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

def html_to_image(html_file, output_file, width, height, dpi=300):
    """
    Convierte un archivo HTML a una imagen de alta calidad
    
    Args:
        html_file (str): Ruta al archivo HTML
        output_file (str): Ruta donde guardar la imagen
        width (int): Ancho de la ventana del navegador
        height (int): Alto de la ventana del navegador
        dpi (int): Resolución de la imagen (puntos por pulgada)
    """
    # Configurar opciones de Chrome
    chrome_options = Options()
    chrome_options.add_argument("--headless")  # Ejecutar en modo headless (sin interfaz gráfica)
    chrome_options.add_argument("--disable-gpu")
    chrome_options.add_argument(f"--window-size={width},{height}")
    chrome_options.add_argument("--hide-scrollbars")
    
    # Configurar la escala de dispositivo para mayor resolución
    # Un valor más alto = imagen de mayor resolución
    scale_factor = dpi / 96  # 96 DPI es la resolución estándar de pantalla
    chrome_options.add_argument(f"--force-device-scale-factor={scale_factor}")
    
    # Inicializar el driver
    driver = webdriver.Chrome(
        service=Service(ChromeDriverManager().install()),
        options=chrome_options
    )
    
    # Cargar el archivo HTML
    html_path = os.path.abspath(html_file)
    driver.get(f"file:///{html_path}")
    
    # Esperar a que se carguen todos los recursos
    time.sleep(2)
    
    # Tomar captura de pantalla
    driver.save_screenshot(output_file)
    
    # Cerrar el driver
    driver.quit()
    
    print(f"Imagen guardada en: {output_file}")

if __name__ == "__main__":
    # Crear directorio para las imágenes si no existe
    os.makedirs("banner_images", exist_ok=True)
    
    # Exportar banner A4
    html_to_image(
        "banner_a4.html", 
        "banner_images/banner_a4.png", 
        width=2480,  # Aproximadamente A4 a 300 DPI
        height=3508,
        dpi=300
    )
    
    # Exportar banner Instagram
    html_to_image(
        "banner_instagram.html", 
        "banner_images/banner_instagram.png", 
        width=3000,  # 1000px a 300 DPI
        height=3000,
        dpi=300
    )