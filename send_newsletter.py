import smtplib
import os
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
import csv
from datetime import datetime

# Configuración de Gmail
GMAIL_USER = "tu_correo@gmail.com"  # Reemplaza con tu correo de Gmail
GMAIL_APP_PASSWORD = "tu_clave_de_aplicacion"  # Reemplaza con tu clave de aplicación
SMTP_SERVER = "smtp.gmail.com"
SMTP_PORT = 587

# Configuración del newsletter
NEWSLETTER_SUBJECT = "🎮 Ofertas Especiales | Ahorrito Gaming"
SENDER_NAME = "Ahorrito Gaming"
REPLY_TO = "soporte@ahorritogaming.cl"  # Opcional: correo de respuesta

# Ruta al archivo CSV con los suscriptores (nombre,email)
SUBSCRIBERS_CSV = "suscriptores.csv"

# Ruta a la carpeta de imágenes para incrustar en el email
IMAGES_FOLDER = "newsletter_images"

# Función para leer el HTML del newsletter
def get_newsletter_html():
    with open("newsletter_template.html", "r", encoding="utf-8") as file:
        return file.read()

# Función para reemplazar placeholders en el HTML
def personalize_newsletter(html_content, subscriber_name):
    # Personaliza el contenido con el nombre del suscriptor
    personalized_html = html_content.replace("Hola Gamer,", f"Hola {subscriber_name},")
    
    # Aquí puedes añadir más personalizaciones si lo deseas
    # Por ejemplo, contenido dinámico basado en preferencias del usuario
    
    return personalized_html

# Función para incrustar imágenes en el email
def embed_images(msg, html_content):
    # Verifica si la carpeta de imágenes existe
    if not os.path.exists(IMAGES_FOLDER):
        print(f"Advertencia: La carpeta {IMAGES_FOLDER} no existe. No se incrustarán imágenes.")
        return html_content
    
    # Diccionario para almacenar los IDs de las imágenes incrustadas
    image_dict = {}
    
    # Busca todas las imágenes en la carpeta
    for filename in os.listdir(IMAGES_FOLDER):
        if filename.lower().endswith(('.png', '.jpg', '.jpeg', '.gif')):
            # Genera un ID único para la imagen
            image_id = f"image_{filename.split('.')[0]}"
            
            # Lee la imagen
            with open(os.path.join(IMAGES_FOLDER, filename), 'rb') as img_file:
                img_data = img_file.read()
            
            # Crea la parte de la imagen
            image = MIMEImage(img_data)
            image.add_header('Content-ID', f'<{image_id}>')
            image.add_header('Content-Disposition', 'inline', filename=filename)
            
            # Añade la imagen al mensaje
            msg.attach(image)
            
            # Guarda el ID para reemplazar en el HTML
            image_dict[filename] = image_id
    
    # Reemplaza las URLs de placeholder con las imágenes incrustadas
    modified_html = html_content
    for filename, image_id in image_dict.items():
        # Busca URLs que contengan el nombre del archivo
        placeholder = f"https://placehold.co/600x300?text={filename.split('.')[0].replace('_', '+')}"
        modified_html = modified_html.replace(placeholder, f"cid:{image_id}")
        
        # También busca por el nombre de archivo directo
        modified_html = modified_html.replace(f"src=\"{filename}\"", f"src=\"cid:{image_id}\"")
    
    return modified_html

# Función para enviar el newsletter a un suscriptor
def send_newsletter(subscriber_name, subscriber_email):
    try:
        # Crear mensaje
        msg = MIMEMultipart('alternative')
        msg['Subject'] = NEWSLETTER_SUBJECT
        msg['From'] = f"{SENDER_NAME} <{GMAIL_USER}>"
        msg['To'] = subscriber_email
        msg['Reply-To'] = REPLY_TO
        
        # Obtener el HTML del newsletter
        html_content = get_newsletter_html()
        
        # Personalizar el contenido
        personalized_html = personalize_newsletter(html_content, subscriber_name)
        
        # Incrustar imágenes
        final_html = embed_images(msg, personalized_html)
        
        # Añadir el HTML al mensaje
        html_part = MIMEText(final_html, 'html')
        msg.attach(html_part)
        
        # Conectar al servidor SMTP
        server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        server.starttls()
        server.login(GMAIL_USER, GMAIL_APP_PASSWORD)
        
        # Enviar el correo
        server.send_message(msg)
        server.quit()
        
        print(f"✅ Newsletter enviado a {subscriber_email}")
        return True
    
    except Exception as e:
        print(f"❌ Error al enviar a {subscriber_email}: {str(e)}")
        return False

# Función principal
def main():
    # Verificar si existe el archivo de suscriptores
    if not os.path.exists(SUBSCRIBERS_CSV):
        print(f"Error: El archivo {SUBSCRIBERS_CSV} no existe.")
        return
    
    # Verificar si existe el archivo de newsletter
    if not os.path.exists("newsletter_template.html"):
        print("Error: El archivo newsletter_template.html no existe.")
        return
    
    # Estadísticas
    total_subscribers = 0
    successful_sends = 0
    
    # Tiempo de inicio
    start_time = datetime.now()
    print(f"Iniciando envío de newsletter: {start_time.strftime('%Y-%m-%d %H:%M:%S')}")
    
    # Leer suscriptores del CSV
    with open(SUBSCRIBERS_CSV, 'r', encoding='utf-8') as file:
        reader = csv.reader(file)
        next(reader, None)  # Saltar la cabecera si existe
        
        for row in reader:
            if len(row) >= 2:
                name = row[0].strip()
                email = row[1].strip()
                
                total_subscribers += 1
                print(f"Enviando a {name} ({email})...")
                
                if send_newsletter(name, email):
                    successful_sends += 1
    
    # Tiempo de finalización
    end_time = datetime.now()
    duration = end_time - start_time
    
    # Mostrar resumen
    print("\n===== RESUMEN DE ENVÍO =====")
    print(f"Total de suscriptores: {total_subscribers}")
    print(f"Envíos exitosos: {successful_sends}")
    print(f"Envíos fallidos: {total_subscribers - successful_sends}")
    print(f"Tiempo total: {duration}")
    print("============================")

if __name__ == "__main__":
    main()