% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/infixes.R, R/type_match.R
\name{\%is\%}
\alias{\%is\%}
\alias{type_match}
\title{Type check against type definition type}
\usage{
val \%is\% type

type_match(type, val, ..., quoted = FALSE)
}
\arguments{
\item{val}{The value of the parameter to type check}

\item{type}{A type to type check against. On the surface, this is a
language object. The meaning of that language object is processed through a
chain of method dispatch.}

\item{name}{The name of the parameter to type check}

\item{envir}{The function environment where \code{name} is defined}

\item{paramvals}{An environment of observed type parameter values. This
environment can be further processed to do type parameter bounds checks.}
}
\value{
A \code{logical} value indicating whether a type specification is met by
the value in the function environment. This function is also called for the
side-effect of mutating the \code{paramvals} environment to collect observed type
parameter values.
}
\description{
Type checking relies on a series of method dispatch to evaluate different
syntactic types of type definitions. See S3 implementations for details.
}
\section{Syntax}{

Type signatures do not follow typical R syntax.

\describe{
\item{\code{"t"}, \code{t}:}{
Attempts to apply \code{t} as an interface predicate, and otherwise
interprets\code{t} as a class. Similar to:
\preformatted{
    # if a predicate function named "t" exists ("is.numeric")
    isTRUE(t(object))

    # if no function named "t" exists ("numeric")
    t <- as.character(t)
    inherts(object, t) || mode(object) == t
    }
}
\item{\code{t1 | t2}:}{
Union. Object is satisfied by \code{t1} or \code{t2}.
}
\item{\code{t(interface)}:}{
Further constrains \code{t} by additional interface predicate.
}
\item{\code{t(interface=result)}:}{
Further constrains \code{t} by an interface, whose result is constrained such
that it must produce \code{result}. Can be interpretted as:
\preformatted{
    type_match(t, object)
    interface(object) == result
    }
}
\item{\code{t(interface :type)}:}{
Further constrains \code{t} by an interface, whose result is constrained such
that it must be of type \code{type}. Can be interpretted as:
\preformatted{
    type_match(t, object)
    type_match(type, interface(object))
    }
}
\item{\code{t[[index :type]]}:}{
Further constrains \code{t} such that the element at \code{index} is constrained by
type \code{type}. Can be interetted as:
\preformatted{
    type_match(t, object)
    type_match(type, t[[index])
    }
}
\item{\code{t[elem_type]}:}{
Further constrains \code{t} such that all elements are constrained by
\code{slice_type}. Can be interetted as:
\preformatted{
    type_match(t, object)
    all(vapply(t, type_match, logical(1L), elem_type))
    }
}
\item{\code{t[slice :elem_type]}:}{
Further constrains \code{t} such that all elements of \code{object[slice]} are
constrained by \code{elem_type}. Can be interpretted as:
\preformatted{
    type_match(t, object)
    all(vapply(object[slice], type_match, logical(1L), elem_type))
    }
}
\item{\code{t(.$elem :elem_type)} or \code{t(elem$elem_type)}:}{
Infix operators can be applied as dot-style lambdas to define a interface
predicate, or the infix operator itself can be used as a shorthand
notation. Can be interpretted as:
\preformatted{
    type_match(t, object)
    type_match(elem_type, object$elem)
    }
}
}
}

\examples{
# match type of object `c(1, 2)` against definition `"numeric"`
# can also be tested using \%is\% (below)
type_match("numeric", c(1, 2))

# character class name
c(1, 2)      \%is\% "numeric"
c("a", "b")  \%is\% "numeric" # FALSE

# name (interpretted as class name)
c(1, 2)      \%is\%  numeric
c("a", "b")  \%is\%  numeric  # FALSE

# interface predicate
c(1, 2)      \%is\%  is.numeric
c("a", "b")  \%is\%  is.numeric

# name type, qualified by interface predicate
1L  \%is\%  numeric(is.finite)
Inf \%is\%  numeric(is.finite)  # FALSE

# name type, qualified by interface return value
list(1, 2)     \%is\%  list(length=2)
list(1, 2, 3)  \%is\%  list(length=2)  # FALSE

# name type, qualified by types by index
list(a = 1, b = "2")  \%is\%  list[[a :numeric, b :character]]
list(a = 1, b = 2)    \%is\%  list[[a :numeric, b :character]]  # FALSE

# name type, qualified by element name type
list(1, 2, 3)    \%is\%  list[numeric]
list(1, 2, "c")  \%is\%  list[numeric]  # FALSE

# name type, qualified by infix behavior
list(a = 1, b = "b")  \%is\%  list(.$a :numeric, .$b :character)
list(a = 1, b = "b")  \%is\%  list(a$numeric, b$character)

# some composite examples
list(1, 2, 3)    \%is\%  list(length=3)[numeric]
list(1, 2)       \%is\%  list(length=3)[numeric]  # FALSE
list(1, 2, "c")  \%is\%  list(length=3)[numeric]  # FALSE


list(1:3, 1:3)  \%is\%  list(length=2)[numeric(length=3)]
list(1:3, 1)    \%is\%  list(length=2)[[1 :numeric(length=3), 2 :numeric]]

iris  \%is\%  data.frame(.$Sepal.Length :numeric, .$Species :factor)
iris  \%is\%  data.frame[1:4 :numeric(length=150), "Species" :factor]
iris  \%is\%  data.frame(nrow=150)[1:4 :numeric, "Species" :factor]

}
\seealso{
Other type-evaluation: 
\code{\link{type_check}()},
\code{\link{type_constrain}()}
}
\concept{type-evaluation}
