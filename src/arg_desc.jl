const AStr = AbstractString
const ColorType = Union{Symbol,Colorant,PlotUtils.ColorSchemes.ColorScheme,Integer}
const TicksType = Union{AVec{Real},Tuple{AVec{Real},AVec{AStr}},Symbol}

link_histogram   = "[`histogram`](https://docs.juliaplots.org/stable/api/#Plots.histogram-Tuple)"
link_histogram2d = "[`histogram2d`](https://docs.juliaplots.org/stable/api/#Plots.histogram2d-Tuple)"

# NOTE: when updating `arg_desc`, don't forget to modify `PlotDocs.make_attr_df` accordingly.
const _arg_desc = KW(
    # series args
    :label              => (AStr, "The label for a series, which appears in a legend. If empty, no legend entry is added."),
    :seriescolor        => (ColorType, "The base color for this series. `:auto` (the default) will select a color from the subplot's `color_palette`, based on the order it was added to the subplot. Also describes the colormap for surfaces."),
    :seriesalpha        => (Real, "The alpha/opacity override for the series. `nothing` (the default) means it will take the alpha value of the color."),
    :seriestype         => (Symbol, "This is the identifier of the type of visualization for this series. Choose from $(_allTypes) or any series recipes which are defined."),
    :linestyle          => (Symbol, "Style of the line (for path and bar stroke). Choose from $(_allStyles)"),
    :linewidth          => (Real, "Width of the line (in pixels)."),
    :linecolor          => (ColorType, "Color of the line (for path and bar stroke). `:match` will take the value from `:seriescolor`, (though histogram/bar types use `:black` as a default)."),
    :linealpha          => (Real, "The alpha/opacity override for the line. `nothing` (the default) means it will take the alpha value of linecolor."),
    :fillrange          => (Union{Real,AVec}, "Fills area between fillrange and `y` for line-types, sets the base for `bar`, `sticks` types, and similar for other types."),
    :fillcolor          => (ColorType, "Color of the filled area of path or bar types. `:match` will take the value from `:seriescolor`."),
    :fillalpha          => (Real, "The alpha/opacity override for the fill area. `nothing` (the default) means it will take the alpha value of fillcolor."),
    :markershape        => (Union{Symbol,Shape,AVec}, "Choose from $(_allMarkers)."),
    :fillstyle          => (Symbol, "Style of the fill area. `nothing` (the default) means solid fill. Choose from :/, :\\, :|, :-, :+, :x."),
    :markercolor        => (ColorType, "Color of the interior of the marker or shape. `:match` will take the value from `:seriescolor`."),
    :markeralpha        => (Real, "The alpha/opacity override for the marker interior. `nothing` (the default) means it will take the alpha value of markercolor."),
    :markersize         => (Union{Real,AVec}, "Size (radius pixels) of the markers."),
    :markerstrokestyle  => (Symbol, "Style of the marker stroke (border). Choose from $(_allStyles)."),
    :markerstrokewidth  => (Real, "Width of the marker stroke (border) in pixels."),
    :markerstrokecolor  => (ColorType, "Color of the marker stroke (border). `:match` will take the value from `:foreground_color_subplot`."),
    :markerstrokealpha  => (Real, "The alpha/opacity override for the marker stroke (border). `nothing` (the default) means it will take the alpha value of markerstrokecolor."),
    :bins               => (Union{Integer,NTuple{2,Integer},AVec,Symbol}, """
                            Defines the number of bins. 

                            Can take in one of the following types:
                            * `Integer` - defines the approximate number of bins to aim for. Not guaranteed to give the exact value.
                                * `bins=10` gives a 1D histogram with about 10 bins.
                                * `bins=10` gives a 2D histogram with about 10 bins for each dimension.
                            * `Tuple{Integer, Integer}` - for two-dimensional histograms, defines the approximate number of bins per dimension. Not guaranteed to give the exact values.
                                * `bins=(10, 20)` gives a 2D histogram with about 10 bins for the `x` dimension and about 20 bins for the `y` dimension.
                            * `Symbol` - defines the auto-binning algorithm to use.
                                * `:auto` (`:fd`, default) - [Freedman-Diaconis' rule](https://en.wikipedia.org/wiki/Histogram#Freedman%E2%80%93Diaconis'_choice)
                                * `:sturges` - [Sturges' rule](https://en.wikipedia.org/wiki/Histogram#Sturges'_formula)
                                * `:sqrt` - [Square root rule](https://en.wikipedia.org/wiki/Histogram#Square-root_choice)
                                * `:rice` - [Rice rule](https://en.wikipedia.org/wiki/Histogram#Rice_rule) 
                                * `:scott` - [Scott's normal reference rule](https://en.wikipedia.org/wiki/Histogram#Scott's_normal_reference_rule)
                            * `AbstractVector` - defines a vector of values for bin edges.
                                * `bins=range(-10, 10, length=21)` gives a histogram with bins starting from -10, ending at 10, and containing 21 break values, giving 20 bins.

                            Relevant attribute for the following series types:
                                * $(link_histogram)
                                * $(link_histogram2d)
                        """),
    :smooth             => (Bool, "Add a regression line ?"),
    :group              => (AVec, "Data is split into a separate series, one for each unique value in `group`."),
    :x                  => (Any, "Input data (first dimension)."),
    :y                  => (Any, "Input data (second dimension)."),
    :z                  => (Any, "Input data (third dimension). May be wrapped by a `Surface` for surface and heatmap types."),
    :marker_z           => (Union{AVec,Function}, "z-values for each series data point, which correspond to the color to be used from a markercolor gradient (`f(x,y,z) -> z_value` or `f(x,y) -> z_value`)."),
    :line_z             => (Union{AVec,Function}, "z-values for each series line segment, which correspond to the color to be used from a linecolor gradient. Note that for N points, only the first N-1 values are used (one per line-segment)."),
    :fill_z             => (AMat, "Matrix of the same size as z matrix, which specifies the color of the 3D surface."),
    :levels             => (Union{AVec,Integer}, "Singleton for number of contours or iterable for contour values. Determines contour levels for a contour type."),
    :permute            => (NTuple{2,Symbol}, "Permutes data and axis properties of the axes given in the tuple, e.g. (:x, :y)."),
    :orientation        => (Symbol, "(deprecated) Horizontal or vertical orientation for bar types. Values `:h`, `:hor`, `:horizontal` correspond to horizontal (sideways, anchored to y-axis), and `:v`, `:vert`, and `:vertical` correspond to vertical (the default)."),
    :bar_position       => (Symbol, "Choose from `:overlay` (default), `:stack`. (warning: may only be partially implemented)."),
    :bar_width          => (Real, " Width of bars in data coordinates. When `nothing`, chooses based on `x` (or `y` when `orientation = :h`)."),
    :bar_edges          => (Bool, "Align bars to edges (true), or centers (the default) ?"),
    :xerror             => (Union{AVec,NTuple{2,AVec}}, "`x` (horizontal) error relative to x-value. If 2-tuple of vectors, the first vector corresponds to the left error (and the second to the right)."),
    :yerror             => (Union{AVec,NTuple{2,AVec}}, "`y` (vertical) error relative to y-value. If 2-tuple of vectors, the first vector corresponds to the bottom error (and the second to the top)."),
    :ribbon             => (Union{Real,AVec}, "Creates a fillrange around the data points."),
    :quiver             => (Union{AVec,NTuple{2,AVec}}, "The directional vectors U,V which specify velocity/gradient vectors for a quiver plot."),
    :arrow              => (Union{Bool,Arrow}, "Defines arrowheads that should be displayed at the end of path line segments (just before a NaN and the last non-NaN point). Used in quiverplot, streamplot, or similar."),
    :normalize          => (Union{Bool,Symbol}, "Histogram normalization mode. Possible values are: false/:none (no normalization, default), true/:pdf (normalize to a discrete PDF, where the total area of the bins is 1), :probability (bin heights sum to 1) and :density (the area of each bin, rather than the height, is equal to the counts - useful for uneven bin sizes)."),
    :weights            => (AVec, """
                            Weights entries in a histogram.

                            `weights` must be a vector of the same length as the data vector `x`.
                            
                            Relevant attribute for the following series types:
                            * $(link_histogram)
                            * $(link_histogram2d)
                            """),
    :show_empty_bins    => (Bool, """
                            Colors in empty bins of a 2D histogram.

                            If `true`, empty bins are colored as the minimum value of the given color scheme.

                            Relevant attribute for the following series types:
                            * $(link_histogram2d)
                            """),
    :contours           => (Bool, "Add contours to the side-grids of 3D plots?  Used in surface/wireframe."),
    :contour_labels     => (Bool, "Show labels at the contour lines ?"),
    :match_dimensions   => (Bool, "For heatmap types: should the first dimension of a matrix (rows) correspond to the first dimension of the plot (`x`-axis) ? Defaults to `false`, which matches the behavior of Matplotlib, Plotly, and others. Note: when passing a function for `z`, the function should still map `(x,y) -> z`."),
    :subplot            => (Union{Integer,Subplot}, "The subplot that this series belongs to."),
    :series_annotations => (Union{AVec,AStr,PlotText}, "These are annotations which are mapped to data points/positions."),
    :primary            => (Bool, "Does this count as a 'real series'? For example, you could have a path (primary), and a scatter (secondary) as two separate series, maybe with different data (see `sticks` recipe for an example). The secondary series will get the same color, etc as the primary."),
    :hover              => (AVec{AStr}, "Text to display when hovering over each data point."),
    :colorbar_entry     => (Bool, "Include this series in the color bar?  Set to `false` to exclude."),
    :z_order            => (Union{Symbol,Integer}, ":front (default), :back or index of position where 1 is farest in the background."),

    # plot args
    :plot_title               => (AStr, "Whole plot title (not to be confused with the title for individual subplots)."),
    :plot_titlevspan          => (Real, "Vertical span of the whole plot title (fraction of the plot height)."),
    :background_color         => (ColorType, " Base color for all backgrounds."),
    :background_color_outside => (ColorType, "Color outside the plot area(s) (`:match` matches `:background_color`)."),
    :foreground_color         => (ColorType, "Base color for all foregrounds."),
    :size                     => (NTuple{2,Integer}, "(width_px, height_px) of the whole Plot."),
    :pos                      => (NTuple{2,Integer}, "(left_px, top_px) position of the GUI window (note: currently unimplemented)."),
    :window_title             => (AStr, "Title of the standalone gui-window."),
    :show                     => (Bool, "Should this command open/refresh a GUI/display ? Allows to display plots in scripts or functions without explicitly calling `display`."),
    :layout                   => (Union{Integer,NTuple{2,Integer},AbstractLayout}, "Number of subplot, grid dimensions, layout (for example `grid(2,2)`), or the return from the `@layout` macro. This builds the layout of subplots."),
    :link                     => (Symbol, "How/whether to link axis limits between subplots. Values: `:none`, `:x` (x axes are linked by columns), `:y` (y axes are linked by rows), `:both` (x and y are linked), `:all` (every subplot is linked together regardless of layout position)."),
    :overwrite_figure         => (Bool, "Should we reuse the same GUI window/figure when plotting (true) or open a new one (false)."),
    :html_output_format       => (Symbol, "When writing html output, what is the format?  `:png` and `:svg` are currently supported."),
    :tex_output_standalone    => (Bool, "When writing tex output, should the source include a preamble for a standalone document class."),
    :inset_subplots           => (AVec{NTuple{2,Any}}, "Optionally pass a vector of (parent,bbox) tuples which are the parent layout and the relative bounding box of inset subplots."),
    :dpi                      => (Real, "Dots Per Inch of output figures."),
    :thickness_scaling        => (Real, "Scale for the thickness of all line elements like lines, borders, axes, grid lines, ... defaults to 1."),
    :display_type             => (Symbol, "When supported, `display` will either open a GUI window or plot inline. Choose from (`:auto`, `:gui`, or `:inline`)."),
    :extra_kwargs             => (Symbol, """
                                 Specify for which element extra keyword args are collected or a KW (Dict{Symbol,Any}) to pass a map of extra keyword args which may be specific to a backend. Choose from (`:plot`, `:subplot`, `:series`), defaults to `:series`.
                                 Example: `pgfplotsx(); scatter(1:5, extra_kwargs=Dict(:subplot=>Dict("axis line shift" => "10pt"))`."""),
    :fontfamily               => (Union{AStr,Symbol}, "Default font family for title, legend entries, tick labels and guides."),
    :warn_on_unsupported      => (Bool, "Warn on unsupported attributes, series types and marker shapes."),

    # subplot args
    :title                       => (AStr, "Subplot title."),
    :titlelocation               => (Symbol, "Position of subplot title. Choose from (`:left`, `:center`, `:right`)."),
    :titlefontfamily             => (Union{AStr,Symbol}, "Font family of subplot title."),
    :titlefontsize               => (Integer, "Font pointsize of subplot title."),
    :titlefonthalign             => (Symbol, "Font horizontal alignment of subplot title. Choose from (:hcenter, :left, :right, :center)."),
    :titlefontvalign             => (Symbol, "Font vertical alignment of subplot title. Choose from (:vcenter, :top, :bottom, :center)."),
    :titlefontrotation           => (Real, "Font rotation of subplot title."),
    :titlefontcolor              => (ColorType, "Color Type. Font color of subplot title."),
    :background_color_subplot    => (ColorType, "Base background color of the subplot (`:match` matches `:background_color`)."),
    :legend_background_color     => (ColorType, "Background color of the legend (`:match` matches :background_color_subplot`)."),
    :background_color_inside     => (ColorType, "Background color inside the plot area (under the grid) (`:match` matches :background_color_subplot`)."),
    :foreground_color_subplot    => (ColorType, "Base foreground color of the subplot (`:match` matches :foreground_color`)."),
    :legend_foreground_color     => (ColorType, "Foreground color of the legend (`:match` matches :foreground_color_subplot`)."),
    :foreground_color_title      => (ColorType, "Color of subplot title (`:match` matches :foreground_color_subplot`)."),
    :color_palette               => (Union{AVec{ColorType},Symbol}, "Iterable (cycle through) or color gradient (generate list from gradient) or `:auto` (generate a color list using `Colors.distiguishable_colors` and custom seed colors chosen to contrast with the background). The color palette is a color list from which series colors are automatically chosen."),
    :legend_position             => (Union{Bool,NTuple{2,Real},Symbol}, """
                                    Show the legend ? Can also be a (x,y) tuple or Symbol (legend position) or angle (angle,inout) tuple. Bottom left corner of legend is placed at (x,y).
                                    Choose from (`:none`, `:best`, `:inline`, `:inside`, `:legend`) or any valid combination of `:(outer ?)(top/bottom ?)(right/left ?)`, i.e.: `:top`, `:topright`, `:outerleft`, `:outerbottomright` ... (note: only some may be supported in each backend)."""),
    :legend_column               => (Integer, "Number of columns in the legend. `-1` stands for maximum number of colums (horizontal legend)."),
    :legend_title_font           => (Font, "Font of the legend title."),
    :legend_font_family          => (Union{AStr,Symbol}, "Font family of legend entries."),
    :legend_font_pointsize       => (Integer, "Font pointsize of legend entries."),
    :legend_font_halign          => (Symbol, "Font horizontal alignment of legend entries. Choose from (:hcenter, :left, :right, :center)."),
    :legend_font_valign          => (Symbol, "Font vertical alignment of legend entries. Choose from (:vcenter, :top, :bottom, :center)."),
    :legend_font_rotation        => (Real, "Font rotation of legend entries."),
    :legend_title_font_color     => (ColorType, "Font color of legend entries."),
    :legend_title                => (AStr, "Legend title."),
    :legend_title_font_family    => (Union{AStr,Symbol}, "Font family of the legend title."),
    :legend_title_font_pointsize => (Integer, "Font pointsize the legend title."),
    :legend_title_font_halign    => (Symbol, "Font horizontal alignment of the legend title. Choose from (:hcenter, :left, :right, :center)."),
    :legend_title_font_valign    => (Symbol, "Font vertical alignment of the legend title. Choose from (:vcenter, :top, :bottom, :center)."),
    :legend_title_font_rotation  => (Real, "Font rotation of the legend title."),
    :legend_title_font_color     => (ColorType, "Font color of the legend title."),
    :colorbar                    => (Union{Bool,Symbol}, "Show the colorbar ? A symbol specifies a colorbar position. Choose from (`:none`, `:best`, `:right`, `:left`, `:top`, `:bottom`, `:legend`): `legend` matches legend value (note: only some may be supported in each backend)."),
    :clims                       => (Union{NTuple{2,Real},Symbol,Function}, "Fixes the limits of the colorbar: values, `:auto`, or a function taking series data in and returning a NTuple{2,Real}."),
    :colorbar_fontfamily         => (Union{AStr,Symbol}, "Font family of colobar entries."),
    :colorbar_ticks              => (TicksType, "Tick values, (tickvalues, ticklabels), or `:auto`."),
    :colorbar_tickfontfamily     => (Union{AStr,Symbol}, "String or Symbol. Font family of colorbar tick labels."),
    :colorbar_tickfontsize       => (Integer, "Font pointsize of colorbar tick entries."),
    :colorbar_tickfontcolor      => (ColorType, "Font color of colorbar tick entries."),
    :colorbar_scale              => (Symbol, "Scale of the colorbar axis. Choose from $(_allScales)."),
    :colorbar_formatter          => (Union{Function,Symbol}, "Choose from (:scientific, :plain, :none, :auto), or a method which converts a number to a string for tick labeling."),
    :legend_font                 => (Font, "Font of legend items."),
    :legend_titlefont            => (Font, "Font of the legend title."),
    :annotations                 => (Union{AVec{Tuple},Tuple{Real,Real,Union{AStr,PlotText,Tuple}}}, "(x,y,text) tuple(s), where text can be String, PlotText (created with `text(args...)`), or a tuple of arguments to `text` (e.g., `(\"Label\", 8, :red, :top)`). Add one-off text annotations at the (x,y) coordinates."),
    :annotationfontfamily        => (Union{AStr,Symbol}, "Font family of annotations."),
    :annotationfontsize          => (Integer, "Font pointsize of annotations."),
    :annotationhalign            => (Symbol, "horizontal alignment of annotations. Choose from (:hcenter, :left, :right, :center)."),
    :annotationvalign            => (Symbol, "Vertical alignment of annotations. Choose from (:vcenter, :top, :bottom, :center)."),
    :annotationrotation          => (Real, "Rotation of annotations in degrees."),
    :annotationcolor             => (ColorType, "Annotations color."),
    :projection                  => (Union{AStr,Symbol}, "`3d` or `polar`."),
    :projection_type             => (Symbol, "3d plots projection type: :auto (backend dependent), :persp(ective), :ortho(graphic)."),
    :aspect_ratio                => (Union{Symbol,Real}, "Plot area is resized so that 1 y-unit is the same size as `aspect_ratio` x-units. With `:none`, images inherit aspect ratio of the plot area. Use `:equal` for unit aspect ratio."),
    :margin                      => (Union{Tuple,Real}, "Number multiplied by `mm`, `px`, etc... or Tuple `(0, :mm)`. Base for individual margins... not directly used. Specifies the extra padding around subplots."),
    :left_margin                 => (Union{Tuple,Real,Symbol}, "Specifies the extra padding to the left of the subplot (`:match` matches `:margin`)."),
    :top_margin                  => (Union{Tuple,Real,Symbol}, "Specifies the extra padding on the top of the subplot (`:match` matches `:margin`)."),
    :right_margin                => (Union{Tuple,Real,Symbol}, "Specifies the extra padding to the right of the subplot (`:match` matches `:margin`)."),
    :bottom_margin               => (Union{Tuple,Real,Symbol}, "Specifies the extra padding on the bottom of the subplot (`:match` matches `:margin`)."),
    :subplot_index               => (Integer, "Internal (not set by user). Specifies the index of this subplot in the Plot's `plt.subplot` list."),
    :colorbar_title              => (AStr, "Title of colorbar."),
    :framestyle                  => (Symbol, "Style of the axes frame. Choose from $(_allFramestyles)."),
    :camera                      => (NTuple{2,Real}, "Sets the view angle (azimuthal, elevation) for 3D plots."),

    # axis args
    :guide                       => (AStr, "Axis guide (label)."),
    :guide_position              => (Symbol, "Position of axis guides. Choose from (:top, :bottom, :left, :right)."),
    :lims                        => (Union{NTuple{2,Real},Symbol}, """
                                    Force axis limits. Only finite values are used (you can set only the right limit with `xlims = (-Inf, 2)` for example).
                                    `:round` widens the limit to the nearest round number ie. [0.1,3.6]=>[0.0,4.0].
                                    `:symmetric` sets the limits to be symmetric around zero.
                                    Set `widen=true` to widen the specified limits (as occurs when lims are not specified)."""),
    :ticks                       => (TicksType, "Tick values, (tickvalues, ticklabels), or `:auto`."),
    :scale                       => (Symbol, "Scale of the axis. Choose from $(_allScales)."),
    :rotation                    => (Real, "Degrees rotation of tick labels."),
    :flip                        => (Bool, "Should we flip (reverse) the axis ?"),
    :formatter                   => (Union{Symbol,Function}, "Choose from (:scientific, :plain or :auto), or a method which converts a number to a string for tick labeling."),
    :tickfontfamily              => (Union{AStr,Symbol}, "Font family of tick labels."),
    :tickfontsize                => (Integer, "Font pointsize of tick labels."),
    :tickfonthalign              => (Symbol, "Font horizontal alignment of tick labels. Choose from (:hcenter, :left, :right, :center)."),
    :tickfontvalign              => (Symbol, "Font vertical alignment of tick labels. Choose from (:vcenter, :top, :bottom, :center)."),
    :tickfontrotation            => (Real, "Font rotation of tick labels."),
    :tickfontcolor               => (ColorType, "Font color of tick labels."),
    :guidefontfamily             => (Union{AStr,Symbol}, "Font family of axes guides."),
    :guidefontsize               => (Integer, "Font pointsize of axes guides."),
    :guidefonthalign             => (Symbol, "Font horizontal alignment of axes guides. Choose from (:hcenter, :left, :right, :center)."),
    :guidefontvalign             => (Symbol, "Font vertical alignment of axes guides. Choose from (:vcenter, :top, :bottom, :center)."),
    :guidefontrotation           => (Real, "Font rotation of axes guides."),
    :guidefontcolor              => (ColorType, "Font color of axes guides."),
    :foreground_color_axis       => (ColorType, "Color of axis ticks (`:match` matches `:foreground_color_subplot`)."),
    :foreground_color_border     => (ColorType, "Color of plot area border/spines (`:match` matches `:foreground_color_subplot`)."),
    :foreground_color_text       => (ColorType, "Color of tick labels (`:match` matches `:foreground_color_subplot`)."),
    :foreground_color_guide      => (ColorType, "Color of axis guides/labels (`:match` matches `:foreground_color_subplot`)."),
    :mirror                      => (Bool, "Switch the side of the tick labels (right or top)."),
    :grid                        => (Union{Bool,Symbol,AStr}, "Show the grid lines ? `true`, `false`, `:show`, `:hide`, `:yes`, `:no`, `:x`, `:y`, `:z`, `:xy`, ..., `:all`, `:none`, `:off`."),
    :foreground_color_grid       => (ColorType, "Color of grid lines (`:match` matches `:foreground_color_subplot`)."),
    :gridalpha                   => (Real, "The alpha/opacity override for the grid lines."),
    :gridstyle                   => (Symbol, "Style of the grid lines. Choose from $(_allStyles)."),
    :gridlinewidth               => (Real, "Width of the grid lines (in pixels)."),
    :foreground_color_minor_grid => (ColorType, "Color of minor grid lines (`:match` matches `:foreground_color_subplot`)."),
    :minorgrid                   => (Bool, "Adds minor grid lines and ticks to the plot. Set minorticks to change number of gridlines."),
    :minorticks                  => (Integer, "Number of minor intervals between major ticks."),
    :minorgridalpha              => (Real, "The alpha/opacity override for the minorgrid lines."),
    :minorgridstyle              => (Symbol, "Style of the minor grid lines. Choose from $(_allStyles)."),
    :minorgridlinewidth          => (Real, "Width of the minor grid lines (in pixels)."),
    :tick_direction              => (Symbol, "Direction of the ticks. Choose from (`:in`, `:out`, `:none`)."),
    :showaxis                    => (Union{Bool,Symbol,AStr}, "Show the axis. `true`, `false`, `:show`, `:hide`, `:yes`, `:no`, `:x`, `:y`, `:z`, `:xy`, ..., `:all`, `:off`."),
    :widen                       => (Union{Bool,Real,Symbol}, """
                                    Widen the axis limits by a small factor to avoid cut-off markers and lines at the borders.
                                    If set to `true`, scale the axis limits by the default factor of $(default_widen_factor). 
                                    A different factor may be specified by setting `widen` to a number.
                                    Defaults to `:auto`, which widens by the default factor unless limits were manually set.
                                    See also the `scale_limits!` function for scaling axis limits in an existing plot."""),
    :draw_arrow                  => (Bool, "Draw arrow at the end of the axis."),
)
