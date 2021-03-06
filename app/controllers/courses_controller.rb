class CoursesController < ApplicationController
  # GET /courses
  # GET /courses.json

  # def statusworld
  #     # @mahteach = @teachers << current_user unless @teachers.include?(current_user)
  #     # @mahlearn = @students << current_user unless @students.include?(current_user)
  #     # @rating = 5

  # end

  # def myclasses
  #   class_status = params[:class_status]
  #   # @courses = Course.all.select { |c| c.students.include? current_user}

  #   #teacher
  #   #student

  #   # @courses = Course.all
  #   # @courses = Course.all.map { |i| i.students}
  #   if class_status == "student"
  #     @courses = Course.all.select { |c| c.students.include? current_user}
  #   else
  #     @courses = Course.all.select { |c| c.teachers.include? current_user}
  #   end


  # end

  def admin_create_course
    @course = Course.new

  end

  # def add_teacher_to_course
  #   @courses = Course.all
  #   @users = User.all
  # end

  def new_course_teacher
    @courses = Course.all
    @users = User.all
  end

  def create_course_teacher
    c = Course.find params['CourseTeacher']['course_id']
    t = User.find params['CourseTeacher']['user_id']

    if CourseTeacher.where(course_id: params['CourseTeacher']['course_id'], teacher_id: params['CourseTeacher']['user_id']).count == 0
      c.teachers << t
      c.save
      flash[:notice] = "YES!"
      redirect_to new_course_teacher_path, notice: "Added user to course"
    else
      flash[:notice] = "NO! DOESNT WORK!"
      redirect_to new_course_teacher_path, notice: "Added user to course"
    end

  end

  # def add_student_to_course
  #   # @courses = Course.all
  #   # @users = User.all
  #   CourseStudent.create(params)
  # end

  def new_course_student
    @courses = Course.all
    @users = User.all
  end

  def create_course_student
    c = Course.find params['CourseStudent']['course_id']
    s = User.find params['CourseStudent']['user_id']


    # if CourseStudent.where(course_id: params['CourseStudent']['student_id'], student_id: params['CourseStudent']['user_id']).count == 0
    if CourseStudent.where(course_id: params['CourseStudent']['course_id'], student_id: params['CourseStudent']['user_id']).count == 0
      c.students << s
      c.save
      flash[:notice] = "YES!"
      redirect_to new_course_student_path, notice: "Added user to course"
    else
      flash[:notice] = "NO! DOESNT WORK!"
      redirect_to new_course_student_path, notice: "Added user to course"
    end

    # - or -
    # CourseStudent.create(params["CourseStudent"])
    # redirect CourseStudent
  end



  def welcome

  end


  def index
    if params[:id]
      @course = Course.find_by_id(params[:id])
      redirect_to(@course) and return if @course
    end

    @courses = Course.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courses }
    end
  end

  def select_course
    @courses = Course.all

  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @course = Course.find(params[:id])
    if signed_in?
      @students = @course.students #assigns a student to that course array which it yields
      @teachers = @course.teachers #course array which it yields teachers
      @teacher = @teachers.include?(current_user)
      @student = @students.include?(current_user)

    end
    @assignments = Assignment.all


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.json
  def new
    @course = Course.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(params[:course])

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render json: @course, status: :created, location: @course }
      else
        format.html { render action: "new" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.json
  def update
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :no_content }
    end
  end
end
