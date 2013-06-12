# -*- encoding : utf-8 -*-
module UsersHelper
  def gravatar_for(user, options = {size: 50})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{options[:size]}"
    image_tag(gravatar_url, alt: user.name, class: "avatar img-rounded")
  end

  def gender(user)
    return "女" if user.gender == 0
    return "男" if user.gender == 1
    return "未知"
  end

  def role(user)
    return "学生" if user.role == 1
    return "老师" if user.role == 0
    return "既是老师也是学生" if user.role == 2
  end

  def student_visible_to_s(user)
    if user.student_visible
      "想学习" 
    else
      "不想学习"
    end
  end

  def teacher_visible_to_s(user)
    if user.teacher_visible
      "想教学" 
    else
      "不想教学"
    end
  end

  def video_for(id)
   '<embed src="http://player.youku.com/player.php/sid/'+id+'/v.swf" allowFullScreen="true" quality="high" width="480" height="400" align="middle" allowScriptAccess="always" type="application/x-shockwave-flash"></embed>' 
  end
end
