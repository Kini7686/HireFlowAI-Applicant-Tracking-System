import { application } from "controllers/application"
import AtsPollController from "controllers/ats_poll_controller"
import PipelineController from "controllers/pipeline_controller"
import ResumeUploadController from "controllers/resume_upload_controller"
import SkillTagsController from "controllers/skill_tags_controller"

application.register("ats-poll", AtsPollController)
application.register("pipeline", PipelineController)
application.register("resume-upload", ResumeUploadController)
application.register("skill-tags", SkillTagsController)
