#En este controlador, es donde se logra registrar un nuevo termostato y la interface
#con ella por el cual se logra mostrar la temperatura actual y la humedad
class ThermostatsController < ApplicationController

  before_action :set_thermostat, only: [:show, :edit, :update, :destroy]

  def index
    if  (current_user!=nil) 
      if (current_user.role == 1)
        @thermostats=Thermostat.all
      else
         @thermostats = current_user.thermostats
      end
    else
        redirect_to root_path
    end
  end

def devise
end
  # GET /thermostats/1
  # GET /thermostats/1.json
def show
  if @thermostat.user_id != current_user.id
    redirect_to '/'
  else
    ciudad = @thermostat.location.city
    ciudad = ciudad.gsub(" ","_") + ",Bolivia"
    responseClim = HTTParty.get('http://api.openweathermap.org/data/2.5/weather?q=' + ciudad + '&lang=sp')
    @tempMax =  responseClim["main"]["temp_max"]
    @tempMin =  responseClim["main"]["temp_min"]
    @hum =  responseClim["main"]["humidity"]
    @description = responseClim["weather"][0]["description"]
    alarm
  end
end

  # GET /thermostats/new
  def new
    @thermostat = Thermostat.new
    @locations = current_user.locations
  end

  # GET /thermostats/1/edit
  def edit
    @locations = current_user.locations
  end

  # POST /thermostats
  # POST /thermostats.json
  def alarm
    @history_thermostats = HistoryThermostat.all
    @thermostat = Thermostat.find(params[:id])
    @history_thermostats = @thermostat.history_thermostats
    @last_history = @history_thermostats.last
    if @last_history != nil
      @alarm = @last_history.thermostat.location.alarm
      if   @alarm != nil
        if @last_history.temperature > @alarm.temp_max || @last_history.temperature < @alarm.temp_min
          flash[:notice] = "Alarma!!"
        end
      end
    end
  end

  def create
    @thermostat = Thermostat.new(thermostat_params)
    @locations = current_user.locations
    @thermostat.user = current_user
    @thermostat.energy = 0
    @thermostat.humidity = 0
    @history = HistoryThermostat.new
    @history.thermostat_id = @thermostat.id
    @history.save
    respond_to do |format|
      if @thermostat.save
        format.html { redirect_to @thermostat, notice: 'El termostato fue creado satisfactoriamente.' }
        format.json { render action: 'show', status: :created, location: @thermostat }
      end
    end
  end

  # PATCH/PUT /thermostats/1
  # PATCH/PUT /thermostats/1.json
  def update
    @locations = current_user.locations
    respond_to do |format|
      if @thermostat.update(thermostat_params)
        format.html { redirect_to @thermostat, notice: 'El termostato fue actualizado satisfactoriamente.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @thermostat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /thermostats/1
  # DELETE /thermostats/1.json
  def destroy
    @thermostat.destroy
    respond_to do |format|
      format.html { redirect_to thermostats_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_thermostat
      @thermostat = Thermostat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def thermostat_params

      params.require(:thermostat).permit(:serial, :temperature, :user_id, :current_temperature, :location_id, :humildity, :energy )

    end
end