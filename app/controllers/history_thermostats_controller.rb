#Este contolador contrala la historia de  los thermostatos

class HistoryThermostatsController < ApplicationController
  before_action :set_history_thermostat, only: [:show, :edit, :update, :destroy]
 
  # GET /history_thermostats
  # GET /history_thermostats.json


  def index
    @history_thermostats = HistoryThermostat.all
    alarm
  end

  # GET /history_thermostats/1
  # GET /history_thermostats/1.json
  def show
    @thermostat = Thermostat.find(params[:id])
    @history_thermostats = @thermostat.history_thermostats
    alarm
  end

  # GET /history_thermostats/new
  def new
    @history_thermostat = HistoryThermostat.new
    alarm
  end

  # GET /history_thermostats/1/edit
  def edit
  end

  # POST /history_thermostats
  # POST /history_thermostats.json
  def alarm
    @last_history = HistoryThermostat.last
    @alarm = @last_history.thermostat.location.alarm
    if   @alarm != nil
     if @last_history.temperature > @alarm.temp_max || @last_history.temperature < @alarm.temp_min
      flash[:danger] = "alarm wrong temperature"
    end
  end

  end

  def create
    @history_thermostat = HistoryThermostat.new
    @history_thermostat.thermostat_id = params[:thermostat_history][:thermostat].first
    @history_thermostat.temperature = params[:thermostat_history][:temperature]
    @history_thermostat.humedad = params[:thermostat_history][:humedad]
    @history_thermostat.exterior = params[:thermostat_history][:exterior]
    @history_thermostat.consumoN = params[:thermostat_history][:consumoN]
    @history_thermostat.consumoA = params[:thermostat_history][:consumoA]
    @history_thermostat.ahorro = @history_thermostat.consumoA - @history_thermostat.consumoN
    respond_to do |format|
      if @history_thermostat.save
        format.html { redirect_to @history_thermostat, notice: 'Historial de termostato creado exitosamente' }
        format.json { render action: 'show', status: :created, location: @history_thermostat }
      end
    end
  end

  # PATCH/PUT /history_thermostats/1
  # PATCH/PUT /history_thermostats/1.json
  def update
    respond_to do |format|
      if @history_thermostat.update(history_thermostat_params)
        format.html { redirect_to @history_thermostat, notice: 'History thermostat was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @history_thermostat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /history_thermostats/1
  # DELETE /history_thermostats/1.json
  def destroy
    @history_thermostat.destroy
    respond_to do |format|
      format.html { redirect_to history_thermostats_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_history_thermostat
      @history_thermostat = HistoryThermostat.where(:thermostat_id => params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def history_thermostat_params
      params.require(:history_thermostat).permit(:temperature, :humidity, :outdoor, :normaly, :current,  :thermostat_id, :save)
    end
end