class StudentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    students = Student.all
    render json: students, status: :ok
  end

  def show
    student = Student.find(params[:id])
    render json: student, status: :ok
  end

  def create
    student = Student.create!(student_params)
    render json: student, status: :created
  rescue ActiveRecord::RecordInvalid => invalid
    render json: { errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
  end

  def update  
    student = Student.find(params[:id])
    if student[:instructor_id]
      student.update(student_params)
      render json: student, status: :accepted
    else
      render json: {errors: "Student not associated with an instructor"}, status: :unprocessable_entity
    end
  end

  def destroy
    student = Student.find(params[:id])
    student.destroy
    head :no_content
  end


  private

  def student_params
    params.permit(:name, :major, :age, :instructor_id)
  end

  def render_not_found_response
    render json: {error: "Student not found"}, status: :not_found
  end

end
