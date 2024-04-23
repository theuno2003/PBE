require "gtk3"
require_relative 'rfid'
require "net/http"
require "json"
require 'i2c/drivers/lcd'

class LCD
	def initialize(address)
		@display = I2C::Drivers::LCD::Display.new('/dev/i2c-1', address, rows=20, cols=4)
		@address = address
	end

	def show_message(message)
		@display.clear
		@display.text(message, 0)
	end

	def show_string(string, line)
		@display.clear
		@display.text(string, line)
	end
end

class RfidWindow < Gtk::Window
	def initialize
		super("Course Manager")
 		set_default_size(600, 250)
		set_window_position(:center)
		signal_connect("destroy") { Gtk.main_quit }
		box = Gtk::Box.new(:vertical, 7)
		add(box)
		@label = Gtk::Label.new("Please, login with your university card", :expand => true)
		@label.override_background_color(0, Gdk::RGBA.new(0, 0, 1, 1))
		box.pack_start(@label, expand: true, fill: true, padding: 0)
		@reading_enabled = true 
	

		@lcd = LCD.new(0x27) # Inicializar la pantalla LCD
		@lcd.show_message("Please login with   your university card")

		@reading_enabled = true # Habilitar la lectura de la tarjeta por defecto
		@dialog_opened = false # Indicar si el diÃ¡logo estÃ¡ abierto

		show_all

		iniciar_lectura_tarjeta # Iniciar la lectura de la tarjeta automÃ¡ticamente
	end

	def actualizar_label(uid)
	GLib::Idle.add do
		begin
			@reading_enabled = false
			# Enviar el UID al servidor para autenticaciÃ³n
			respuesta = enviar_consulta("http://192.168.79.114:3000/#{uid}")

			# Parsear la respuesta JSON
			respuesta_json = JSON.parse(respuesta)

			if respuesta_json["error"]
				mostrar_error(respuesta_json["error"])
			else
				nombre = respuesta_json["nombreCliente"] || "Nombre no encontrado"
				mostrar_nombre(nombre)

				unless @dialog_opened
					solicitar_consulta(uid)
					@dialog_opened = true
				end
			end
			rescue StandardError => e
			mostrar_error("Error al obtener informaciÃ³n del servidor: #{e.message}")
		end

		# Indicar que el proceso ha terminado
		GLib::Source::REMOVE
	end
	end

	def mostrar_nombre(nombre)
	GLib::Idle.add do
		# Actualizar el contenido del LCD con el nombre del estudiante autenticado
		@lcd.show_string("      Welcome", 1)
		@lcd.show_string("   #{nombre}", 2)

		# Mostrar el nombre del estudiante autenticado en la etiqueta
		@label.set_text("Welcome, #{nombre}")
		@label.override_background_color(0, Gdk::RGBA.new(1, 0, 0, 1))
		GLib::Source::REMOVE
	end
end

def enviar_consulta(url)
	uri = URI.parse(url)
	response = Net::HTTP.get_response(uri)
	response.body
end

def mostrar_error(error)
	GLib::Idle.add do
		# Mostrar el mensaje de error en la etiqueta
		@label.set_text("Error: #{error}")
		@label.override_background_color(0, Gdk::RGBA.new(1, 0, 0, 1))

		# Mostrar el mensaje de error en el LCD
		@lcd.show_message("Error: #{error}")
		GLib::Source::REMOVE
	end
end

def solicitar_consulta(uid)
	GLib::Idle.add do
		dialog = Gtk::Dialog.new(
		title: "Course Manager",
		parent: self,
		flags: Gtk::DialogFlags::MODAL,
		buttons: [[Gtk::Stock::OK, Gtk::ResponseType::ACCEPT], [Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL]])

		content_area = dialog.child
		content_area.add(Gtk::Label.new("Enter your query:"))

		entry = Gtk::Entry.new
		content_area.add(entry)
		entry.set_text("")

		dialog.show_all
		response = dialog.run

		if response == Gtk::ResponseType::ACCEPT
			consulta = entry.text
			ejecutar_consulta(consulta, uid)
		end

		dialog.destroy
		GLib::Source::REMOVE
	end
end

def ejecutar_consulta(consulta, uid)
	Thread.new {
	begin
		# Enviar la consulta al servidor y recibir la respuesta
		url = "http://192.168.79.114:3000/#{uid}?consulta=#{consulta}"
		respuesta = enviar_consulta(url)

		puts "Respuesta de la consulta '#{consulta}':"
		puts respuesta

		mostrar_consulta_grafica(consulta,respuesta)

		rescue StandardError => e
			mostrar_error("Error al ejecutar consulta: #{e.message}")
	end
	}
end




def mostrar_consulta_grafica(tipo_consulta, respuesta)
respuesta_json = JSON.parse(respuesta)
  datos = respuesta_json[tipo_consulta]

  # Crear una ventana para mostrar la respuesta
  ventana_respuesta = Gtk::Window.new("Consulta: #{tipo_consulta.capitalize}")
  ventana_respuesta.set_default_size(600, 400)
listbox = Gtk::ListBox.new
  listbox.set_selection_mode(Gtk::SelectionMode::NONE)
header_labels = []
 case tipo_consulta
  when "tasks"
    header_labels = ["Date", "Subject", "Name"]
 when "timetables"
    header_labels = ["Day", "Time", "Subject", "Room"]
  when "marks"
    header_labels = ["Subject", "Mark"]
  end
header_row = Gtk::ListBoxRow.new
  header_box = Gtk::Box.new(:horizontal, 10)
  header_labels.each do |header|
    header_box.pack_start(Gtk::Label.new(header), expand: true, fill: true, padding: 10)
  end
 header_row.add(header_box)
  listbox.add(header_row)
 datos.each do |dato|
    row = Gtk::ListBoxRow.new
    row_box = Gtk::Box.new(:horizontal, 10)
 case tipo_consulta
    when "tasks"
      row_box.pack_start(Gtk::Label.new(dato["date"]), expand: true, fill: true, padding: 10)
      row_box.pack_start(Gtk::Label.new(dato["subject"]), expand: true, fill: true, padding: 10)
      row_box.pack_start(Gtk::Label.new(dato["name"]), expand: true, fill: true, padding: 10)
when "timetables"
      row_box.pack_start(Gtk::Label.new(dato["day"]), expand: true, fill: true, padding: 10)
      row_box.pack_start(Gtk::Label.new(dato["time"]), expand: true, fill: true, padding: 10)
      row_box.pack_start(Gtk::Label.new(dato["subject"]), expand: true, fill: true, padding: 10)
      row_box.pack_start(Gtk::Label.new(dato["room"]), expand: true, fill: true, padding: 10)
    when "marks"
      row_box.pack_start(Gtk::Label.new(dato["subject"]), expand: true, fill: true, padding: 10)
      row_box.pack_start(Gtk::Label.new(dato["mark"]), expand: true, fill: true, padding: 10)
    end
 row.add(row_box)
    listbox.add(row)
  end
scrolled_window = Gtk::ScrolledWindow.new
  scrolled_window.add(listbox)

  ventana_respuesta.add(scrolled_window)
  ventana_respuesta.show_all

end




def iniciar_lectura_tarjeta
	Thread.new {
	rf = Rfid.new
	loop do
		if @reading_enabled
			uid = rf.read_uid
			actualizar_label(uid)
		else
			break
		end
		sleep(0.1)
	end
	}
end
end

win = RfidWindow.new
Gtk.main

