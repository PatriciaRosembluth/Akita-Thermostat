#Este es el controlador de problemas, se administra los problemas desde u reporte
#y su respectiva status apartir de su reporte.
class IssuesController < ApplicationController

  before_action :set_issue, only: [:change_status, :open,  :show, :edit, :update, :destroy]
  #respond_to :js, only: :change_status

  # GET /issues
  # GET /issues.json
  def index
    if (current_user!=nil)
      @issues = Issue.all
    else
      redirect_to root_path
    end
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
  end

  def change_status
    @issue.change_status
    respond_to do |format|
      format.html { redirect_to "/issues/history/" + @issue.thermostat_id.to_s }
      format.json { head :no_content }
    end
  end

  def open
    @issue.open
      respond_to do |format|
      format.html { redirect_to issues_url }
      format.json { head :no_content }
    end
  end


  def history
    @thermostat = Thermostat.find(params[:id])
    @issues = @thermostat.issues
  end

  # GET /issues/new
  def new
    @issue = Issue.new
    @thermostat = Thermostat.find(params[:id])
    @issue.thermostat = @thermostat
  end

  # GET /issues/1/edit
  def edit

  end

  def resolution
    @issue = Issue.find(params[:id])
    @issue.status = 'RESUELTO'
    @issue.save

  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(issue_params)
    @issue.status = 'ABIERTO'
    @issue.resolution = ''
    respond_to do |format|
      if @issue.save
        format.html { redirect_to @issue, notice: 'Problema registrado exitosamente' }
        format.json { render action: 'show', status: :created, location: @issue }
      else
        format.html { render action: 'new' }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to @issue, notice: 'Problema editado exitosamente' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue.destroy
    respond_to do |format|
      format.html { redirect_to issues_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_params
      params.require(:issue).permit(:thermostat_id, :description, :status, :resolution)
    end
end
