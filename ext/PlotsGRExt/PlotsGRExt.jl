module PlotsGRExt

using GR: GR
using Plots: Plots
# TODO: eliminate this list
using Plots:
    bbox,
    left,
    right,
    bottom,
    top,
    plotarea,
    axis_drawing_info,
    axis_drawing_info_3d,
    _guess_best_legend_position,
    labelfunc_tex,
    _cycle,
    isortho,
    isautop,
    heatmap_edges,
    is_uniformly_spaced,
    DPI

using RecipesPipeline: RecipesPipeline
using NaNMath: NaNMath
using Plots.Arrows
using Plots.Axes
using Plots.Annotations
using Plots.Colorbars
using Plots.Colorbars: cbar_gradient, cbar_fill, cbar_line
using Plots.Colors
using Plots.Commons
using Plots.Fonts
using Plots.Fonts: Font, PlotText
using Plots.PlotMeasures
using Plots.PlotsPlots
using Plots.PlotsSeries
using Plots.Subplots
using Plots.Shapes
using Plots.Shapes: Shape
using Plots.Ticks

# These are overriden by GR
import Plots: labelfunc, _update_min_padding!, _show, _display, closall

include("initialization.jl")
include("gr.jl")

end # module