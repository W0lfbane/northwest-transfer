class ProjectMailer < ApplicationMailer
    def project_created(user, project)
        @user = user
        @project = project
        mail(to: @user.email, subject: "New project created: #{project.title}")
    end
end
