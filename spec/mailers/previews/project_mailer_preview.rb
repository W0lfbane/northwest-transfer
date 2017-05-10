# Preview all emails at http://localhost:3000/rails/mailers/project_mailer
class ProjectMailerPreview < ActionMailer::Preview
  def project_created
    ProjectMailer.project_created(User.first, Project.first)
  end
end