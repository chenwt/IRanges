\name{intra-range-methods}

\alias{intra-range-methods}

\alias{shift}
\alias{shift,Ranges-method}
\alias{shift,IPos-method}
\alias{shift,Views-method}
\alias{shift,RangesList-method}
\alias{shift,CompressedIRangesList-method}

\alias{narrow}
\alias{narrow,Ranges-method}
\alias{narrow,Views-method}
\alias{narrow,RangesList-method}
\alias{narrow,CompressedIRangesList-method}
\alias{narrow,MaskCollection-method}

\alias{resize}
\alias{resize,Ranges-method}
\alias{resize,RangesList-method}
\alias{resize,IntervalList-method}
\alias{resize,CompressedIRangesList-method}

\alias{flank}
\alias{flank,Ranges-method}
\alias{flank,RangesList-method}
\alias{flank,CompressedIRangesList-method}

\alias{promoters}
\alias{promoters,Ranges-method}
\alias{promoters,Views-method}
\alias{promoters,RangesList-method}
\alias{promoters,CompressedIRangesList-method}

\alias{reflect}
\alias{reflect,Ranges-method}

\alias{restrict}
\alias{restrict,Ranges-method}
\alias{restrict,RangesList-method}
\alias{restrict,CompressedIRangesList-method}

\alias{threebands}
\alias{threebands,IRanges-method}

\alias{Ops,Ranges,numeric-method}
\alias{Ops,Ranges,ANY-method}
\alias{Ops,CompressedIRangesList,numeric-method}
\alias{Ops,RangesList,numeric-method}


\title{Intra range transformations of a Ranges, Views, RangesList,
       or MaskCollection object}

\description{
  Range-based transformations are grouped in 2 categories:
  \enumerate{
    \item \emph{Intra range transformations} (e.g. \code{shift()})
          transform each range individually (and independently of the other
          ranges). They return an object \emph{parallel} to the input object,
          that is, where the i-th range corresponds to the i-th range in the
          input.
          Those transformations are described below.

    \item \emph{Inter range transformations} (e.g. \code{\link{reduce}()})
          transform all the ranges together as a set to produce a new set
          of ranges. They return an object that is generally \emph{NOT}
          parallel to the input object.
          Those transformations are described in the \link{inter-range-methods}
          man page (see \code{?`\link{inter-range-methods}`}).
  }

  Except for \code{threebands()}, all the transformations described in this
  man page are \emph{endomorphisms} that operate on a single "range-based"
  object, that is, they transform the ranges contained in the input object
  and return them in an object of the \emph{same class} as the input object.
}

\usage{
## shift()
shift(x, shift=0L, use.names=TRUE)

## narrow()
narrow(x, start=NA, end=NA, width=NA, use.names=TRUE)

## resize()
resize(x, width, fix="start", use.names=TRUE, ...)

## flank()
flank(x, width, start=TRUE, both=FALSE, use.names=TRUE, ...)

## promoters()
promoters(x, upstream=2000, downstream=200, ...)

## reflect()
reflect(x, bounds, use.names=TRUE)

## restrict()
restrict(x, start=NA, end=NA, keep.all.ranges=FALSE, use.names=TRUE)

## threebands()
threebands(x, start=NA, end=NA, width=NA)
}

\arguments{
  \item{x}{
    A \link{Ranges}, \link{Views}, \link{RangesList}, or \link{MaskCollection}
    object.
  }
  \item{shift}{
    An integer vector containing the shift information. Recycled as 
    necessary so that each element corresponds to a range in \code{x}.
    It can also be an \link{IntegerList} object if \code{x} is a
    \link{RangesList} object.
  }
  \item{use.names}{
    \code{TRUE} or \code{FALSE}. Should names be preserved?
  }
  \item{start, end}{
    \itemize{
      \item If \code{x} is a \link{Ranges} or \link{Views} object:
            A vector of integers for all functions except for \code{flank}.
            For \code{restrict}, the supplied \code{start} and \code{end}
            arguments must be vectors of integers, eventually with NAs, that
            specify the restriction interval(s). Recycled as necessary so
            that each element corresponds to a range in \code{x}.
            Same thing for \code{narrow} and \code{threebands}, except that
            here \code{start} and \code{end} must contain coordinates relative
            to the ranges in \code{x}. See the Details section below.
            For \code{flank}, \code{start} is a logical indicating whether
            \code{x} should be flanked at the start (\code{TRUE}) or the end
            (\code{FALSE}). Recycled as necessary so that each element
            corresponds to a range in \code{x}.
      \item If \code{x} is a \link{RangesList} object:
            For \code{flank}, \code{start} must be either a logical vector
            or a \link{LogicalList} object indicating whether \code{x} should
            be flanked at the start (\code{TRUE}) or the end (\code{FALSE}).
            Recycled as necessary so that each element corresponds to a range
            in \code{x}. For \code{narrow}, \code{start} and \code{end} must
            be either an integer vector or an \link{IntegerList} object
            containing coordinates relative to the current ranges.
            For \code{restrict}, \code{start} and \code{end} must be either
            an integer vector or an \link{IntegerList} object (possibly
            containing NA's).
    }
  }
  \item{width}{
    \itemize{
      \item If \code{x} is a \link{Ranges} or \link{Views} object:
            For \code{narrow} and \code{threebands}, a vector of integers,
            eventually with NAs. See the SEW (Start/End/Width) interface for
            the details (\code{?solveUserSEW}).
            For \code{resize} and \code{flank}, the width of the resized or
            flanking regions. Note that if \code{both} is \code{TRUE}, this
            is effectively doubled. Recycled as necessary so that each
            element corresponds to a range in \code{x}.
      \item If \code{x} is a \link{RangesList} object:
            For \code{resize} and \code{flank}, either an integer vector or an
            \link{IntegerList} object containing the width of the flanking
            or resized regions. Recycled as necessary so that each element
            corresponds to a range in \code{x}. (Note for \code{flank}:
            if \code{both} is \code{TRUE}, this is effectively doubled.)
            For \code{narrow}, either an integer vector or a \link{IntegerList}
            object containing the widths to narrow to. See the SEW
            (Start/End/Width) interface for the details (\code{?solveUserSEW}).
    }
  }
  \item{fix}{
    \itemize{
      \item If \code{x} is a \link{Ranges} or \link{Views} object:
            A character vector or character-Rle of length 1 or \code{length(x)}
            containing the values \code{"start"}, \code{"end"}, and
            \code{"center"} denoting what to use as an anchor for each
            element in \code{x}.
      \item If \code{x} is a \link{RangesList} object:
            A character vector of length 1, a \link{CharacterList} object,
            or a character-RleList object containing the values
            \code{"start"}, \code{"end"}, and \code{"center"} denoting what
            to use as an anchor for each element in \code{x}.
    }
  }
  \item{...}{
    Additional arguments for methods.
  }
  \item{both}{
    If \code{TRUE}, extends the flanking region \code{width} positions
    \emph{into} the range. The resulting range thus straddles the end
    point, with \code{width} positions on either side.
  }
  \item{upstream, downstream}{
    Single \code{integer} values >= 0L. \code{upstream} defines the number 
    of nucleotides toward the 5' end and \code{downstream} defines the number
    toward the 3' end, relative to the transcription start site. Promoter 
    regions are formed by merging the upstream and downstream ranges.

    Default values for \code{upstream} and \code{downstream} were chosen based
    on our current understanding of gene regulation. On average, promoter
    regions in the mammalian genome are 5000 bp upstream and downstream of the 
    transcription start site.
  }
  \item{bounds}{
    An \link{IRanges} object to serve as the reference bounds for the
    reflection, see below.
  }
  \item{keep.all.ranges}{
    \code{TRUE} or \code{FALSE}. Should ranges that don't overlap with
    the restriction interval(s) be kept?
    Note that "don't overlap" means that they end strictly before
    \code{start - 1} or start strictly after \code{end + 1}.
    Ranges that end at \code{start - 1} or start at \code{end + 1}
    are always kept and their width is set to zero in the returned
    \link{IRanges} object.
  }
}

\details{
  Unless specified otherwise, when \code{x} is a \link{RangesList} object,
  any transformation described here is equivalent to applying the
  transformation to each \link{RangesList} top-level element separately.

  \subsection{shift}{

    \code{shift} shifts all the ranges in \code{x} by the amount specified
    by the \code{shift} argument.

  }\subsection{narrow}{

    \code{narrow} narrows the ranges in \code{x} i.e. each range in the
    returned \link{Ranges} object is a subrange of the corresponding
    range in \code{x}.
    The supplied start/end/width values are solved by a call to
    \code{solveUserSEW(width(x), start=start, end=end, width=width)}
    and therefore must be compliant with the rules of the SEW
    (Start/End/Width) interface (see \code{?\link{solveUserSEW}}
    for the details).
    Then each subrange is derived from the original range according
    to the solved start/end/width values for this range. Note that those
    solved values are interpreted relatively to the original range.

  }\subsection{resize}{

    \code{resize} resizes the ranges to the specified width where either
    the start, end, or center is used as an anchor.

  }\subsection{flank}{

    \code{flank} generates flanking ranges for each range in \code{x}. If
    \code{start} is \code{TRUE} for a given range, the flanking occurs at
    the start, otherwise the end. The widths of the flanks are given by
    the \code{width} parameter. The widths can be negative, in which case
    the flanking region is reversed so that it represents a prefix or
    suffix of the range in \code{x}. The \code{flank} operation is
    illustrated below for a call of the form \code{flank(x, 3, TRUE)},
    where \code{x} indicates a range in \code{x} and \code{-} indicates
    the resulting flanking region:
    \preformatted{    ---xxxxxxx}
    If \code{start} were \code{FALSE}:
    \preformatted{       xxxxxxx---}
    For negative width, i.e. \code{flank(x, -3, FALSE)}, where \code{*}
    indicates the overlap between \code{x} and the result:
    \preformatted{       xxxx***}
    If \code{both} is \code{TRUE}, then, for all ranges in \code{x}, the
    flanking regions are extended \emph{into} (or out of, if width is
    negative) the range, so that the result straddles the given endpoint
    and has twice the width given by \code{width}. This is illustrated below
    for \code{flank(x, 3, both=TRUE)}:
    \preformatted{    ---***xxxx}

  }\subsection{promoters}{

    \code{promoters} generates promoter ranges for each range in \code{x}
    relative to the transcription start site (TSS), where TSS is 
    \code{start(x)}. The promoter range is expanded around the TSS 
    according to the \code{upsteam} and \code{downstream} arguments.
    \code{upstream} represents the number of nucleotides in the 5' 
    direction and \code{downstream} the number in the 3' direction. 
    The full range is defined as, 
    (start(x) - upstream) to (start(x) + downstream - 1). 
    For documentation for using \code{promoters} on a
    \link[GenomicRanges]{GRanges} object see
    \code{?`\link[GenomicRanges]{promoters,GenomicRanges-method}`} in
    the \pkg{GenomicRanges} package.

  }\subsection{reflect}{

    \code{reflect} "reflects" or reverses each range in \code{x} relative to
    the corresponding range in \code{bounds}, which is recycled as
    necessary. Reflection preserves the width of a range, but shifts it
    such the distance from the left bound to the start of the range
    becomes the distance from the end of the range to the right
    bound. This is illustrated below, where \code{x} represents
    a range in \code{x} and \code{[} and \code{]} indicate the bounds:
    \preformatted{      [..xxx.....]
      becomes
      [.....xxx..]}

  }\subsection{restrict}{

    \code{restrict} restricts the ranges in \code{x} to the interval(s)
    specified by the \code{start} and \code{end} arguments.

  }\subsection{threebands}{

    \code{threebands} extends the capability of \code{narrow} by returning
    the 3 ranges objects associated to the narrowing operation.
    The returned value \code{y} is a list of 3 ranges objects named
    \code{"left"}, \code{"middle"} and \code{"right"}.
    The middle component is obtained by calling \code{narrow} with the
    same arguments (except that names are dropped). The left and right
    components are also instances of the same class as \code{x} and they
    contain what has been removed on the left and right sides (respectively)
    of the original ranges during the narrowing.

    Note that original object \code{x} can be reconstructed from the
    left and right bands with \code{punion(y$left, y$right, fill.gap=TRUE)}.

  }
}

\author{H. Pagès, M. Lawrence, and P. Aboyoun}

\seealso{
  \itemize{
    \item \link{inter-range-methods} for inter range transformations.

    \item The \link{Ranges}, \link{Views}, \link{RangesList},
          and \link{MaskCollection} classes.

    \item The \link[GenomicRanges]{intra-range-methods} man page in the
          \pkg{GenomicRanges} package for \emph{intra range transformations}
          of genomic ranges.

    \item \link{setops-methods} for set operations on \link{IRanges}
          objects.

    \item \code{\link[S4Vectors]{endoapply}} in the \pkg{S4Vectors} package.
  }
}

\examples{
## ---------------------------------------------------------------------
## shift()
## ---------------------------------------------------------------------

## On a Ranges object:
ir1 <- successiveIRanges(c(19, 5, 0, 8, 5))
ir1
shift(ir1, shift=-3)

## On a RangesList object:
range1 <- IRanges(start=c(1, 2, 3), end=c(5, 2, 8))
range2 <- IRanges(start=c(15, 45, 20, 1), end=c(15, 100, 80, 5))
range3 <- IRanges(start=c(-2, 6, 7), width=c(8, 0, 0))  # with empty ranges
collection <- IRangesList(one=range1, range2, range3)
shift(collection, shift=5)  # same as endoapply(collection, shift, shift=5)

## Sanity check:
res1 <- shift(collection, shift=5)
res2 <- endoapply(collection, shift, shift=5)
stopifnot(identical(res1, res2))

## ---------------------------------------------------------------------
## narrow()
## ---------------------------------------------------------------------

## On a Ranges object:
ir2 <- ir1[width(ir1) != 0]
narrow(ir2, start=4, end=-2)
narrow(ir2, start=-4, end=-2)
narrow(ir2, end=5, width=3)
narrow(ir2, start=c(3, 4, 2, 3), end=c(12, 5, 7, 4))

## On a RangesList object:
narrow(collection[-3], start=2)
narrow(collection[-3], end=-2)

## On a MaskCollection object:
mask1 <- Mask(mask.width=29, start=c(11, 25, 28), width=c(5, 2, 2))
mask2 <- Mask(mask.width=29, start=c(3, 10, 27), width=c(5, 8, 1))
mask3 <- Mask(mask.width=29, start=c(7, 12), width=c(2, 4))
mymasks <- append(append(mask1, mask2), mask3)
mymasks
narrow(mymasks, start=8)

## ---------------------------------------------------------------------
## resize()
## ---------------------------------------------------------------------

## On a Ranges object:
resize(ir2, 200)
resize(ir2, 2, fix="end")

## On a RangesList object:
resize(collection, width=200)

## ---------------------------------------------------------------------
## flank()
## ---------------------------------------------------------------------

## On a Ranges object:
ir3 <- IRanges(c(2,5,1), c(3,7,3))
flank(ir3, 2)
flank(ir3, 2, start=FALSE)
flank(ir3, 2, start=c(FALSE, TRUE, FALSE))
flank(ir3, c(2, -2, 2))
flank(ir3, 2, both = TRUE)
flank(ir3, 2, start=FALSE, both=TRUE)
flank(ir3, -2, start=FALSE, both=TRUE)

## On a RangesList object:
flank(collection, width=10)

## ---------------------------------------------------------------------
## promoters()
## ---------------------------------------------------------------------

## On a Ranges object:
ir4 <- IRanges(20:23, width=3)
promoters(ir4, upstream=0, downstream=0) ## no change
promoters(ir4, upstream=0, downstream=1) ## start value only
promoters(ir4, upstream=1, downstream=0) ## single upstream nucleotide 

## On a RangesList object:
promoters(collection, upstream=5, downstream=2)

## ---------------------------------------------------------------------
## reflect()
## ---------------------------------------------------------------------

## On a Ranges object:
bounds <- IRanges(c(0, 5, 3), c(10, 6, 9))
reflect(ir3, bounds)

## reflect() does not yet support RangesList objects!

## ---------------------------------------------------------------------
## restrict()
## ---------------------------------------------------------------------

## On a Ranges object:
restrict(ir1, start=12, end=34)
restrict(ir1, start=20)
restrict(ir1, start=21)
restrict(ir1, start=21, keep.all.ranges=TRUE)

## On a RangesList object:
restrict(collection, start=2, end=8)

## ---------------------------------------------------------------------
## threebands()
## ---------------------------------------------------------------------

## On a Ranges object:
z <- threebands(ir2, start=4, end=-2)
ir2b <- punion(z$left, z$right, fill.gap=TRUE)
stopifnot(identical(ir2, ir2b))
threebands(ir2, start=-5)

## threebands() does not support RangesList objects.
}

\keyword{utilities}
