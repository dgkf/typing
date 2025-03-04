% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/type_match.R
\name{typeify}
\alias{typeify}
\title{What is a type, but a miserable pile of secrets?}
\usage{
typeify(obj)
}
\description{
The existential question of object types in a dynamically typed language.
This line of "type" is a bit arbitrary. There are plenty of dimensions that
could be considered as other gating criteria for type identity.
}
\details{
You may prefer that objects of the same type always have attributes of the
same types, or attributes that are entirely identical. For the sake of
documenting some edge cases for consideration:
}
\section{Motivating Cases}{


\code{factor} variables might be considered identical only if they have the same
levels, akin to an enum. In this sense, the value of the \code{"label"} attribute
should be identical.

However, if attribute values must be identical, then likewise any named
object would need to have identical names to match.

Even if attributes just require the same type, then even \code{data.frame}s would
not be homogenous types, since \code{row.names} may be \code{numeric} or \code{character}.

With that in mind, the definition of a type has been left a bit loose.
Without a stronger type system to support it, anything more exhaustive would
be overbearing.
}

