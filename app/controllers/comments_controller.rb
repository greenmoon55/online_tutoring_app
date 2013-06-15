# -*- encoding : utf-8 -*-
class CommentsController < ApplicationController
before_filter :require_signin, only: [:create, :destroy, :update]

  def destroy
    student_id = params[:student_id]
    teacher_id = params[:teacher_id]
    User.find(teacher_id).comments.find_by_student_id(student_id).destroy
    flash[:success] = "删除成功"
    redirect_to user_path(teacher_id)
  end
  
  def create
    student_id = params[:student_id]
    teacher_id = params[:teacher_id]
    evaluation = params[:evaluation]
    if evaluation.blank?
      flash[:error] = "评论不能为空"
    else
        User.find(teacher_id).comments.create!(student_id: student_id, evaluation: evaluation)
    end
    redirect_to user_path(teacher_id)
  end
  
  def update
    student_id = params[:student_id]
    teacher_id = params[:teacher_id]
    evaluation = params[:evaluation]
    if evaluation.blank?
      flash[:error] = "评论不能为空"
    else
      User.find(teacher_id).comments.find_by_student_id(student_id).update_attributes(evaluation: params[:evaluation])
    end
    redirect_to user_path(teacher_id)
  end    
end
