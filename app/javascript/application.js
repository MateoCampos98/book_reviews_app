// controllers/index.js
import { application } from "./application"
import { autoloadControllers } from "@hotwired/stimulus-importmap-autoloader"

autoloadControllers(application)