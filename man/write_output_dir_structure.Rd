% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write_output.R
\name{write_output_dir_structure}
\alias{write_output_dir_structure}
\title{Create output directory structure for a given job and task.}
\usage{
write_output_dir_structure(output_dir, job_id, task_id)
}
\arguments{
\item{output_dir}{A string specifying the directory where output, logs, and
other pipeline artifacts will be saved. Defaults to the root directory ("/").}

\item{job_id}{A string specifying the job.}

\item{task_id}{A string specifying the task.}
}
\value{
The path to the base output directory (invisible).
}
\description{
This function generates the necessary directory structure for storing output
files related to a job and its tasks, including directories for raw samples
and summarized quantiles.
}
\seealso{
Other write_output: 
\code{\link{sample_processing_functions}},
\code{\link{write_model_outputs}()}
}
\concept{write_output}
