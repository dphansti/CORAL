//shiny output binding
var binding = new Shiny.OutputBinding();

binding.find = function(scope) {
  return $(scope).find(".circleNetwork");
};

binding.renderValue = function(el, data) {
  //empty the div so that it removes the graph when you change data
  $(el).empty();

  if(data!=null){
    //////////.JS//////////
    var radius = 400;
      width = 940,
      height = 940;

    var cluster = d3.layout.cluster()
        .size([360, radius - 60]);

    var diagonal = d3.svg.diagonal.radial()
      .projection(function(d) { return [d.y, d.x / 180 * Math.PI]; });

    var svg = d3.select("#" + $(el).attr('id')).append("svg")
      .attr("width", width)
      .attr("height", height)
      .attr("xmlns","http://www.w3.org/2000/svg")
      .call(d3.behavior.zoom().on("zoom", function () {
          svg.attr("transform", "translate(" + d3.event.translate + ")" + " scale(" + d3.event.scale + ")");
      }))
      .append("g")
      .attr("transform", "translate(" + (radius + 150) + "," + radius + ")");

    d3.json($(el).attr('jsonfilename'), function(error, root) {

      var nodes = cluster.nodes(root);

      var link = svg.selectAll("path.link")
          .data(cluster.links(nodes))
          .enter().append("path")
          .attr("class", "link")
          .attr("d", diagonal)
          .attr("stroke-width", 1.5)
          .attr("stroke", function(d) { return d3.rgb(d.target.branchcol); })
          .attr("fill","none")
          .attr("pointer-events","none");

      var node = svg.selectAll("g.node")
          .data(nodes)
          .enter().append("g")
          .attr("class", "node")
          .attr("stroke-width", 1.5)
          .attr("stroke", "white")
          .attr("transform", function(d) { return "rotate(" + (d.x - 90) + ")translate(" + d.y + ")"; })
          .on("mouseover", mouseover)
          .on("mouseout", mouseout);

      node.append("circle")
          .attr("r", function(d) { return d.noderadius; })
          .attr("stroke",function(d) { return d3.rgb(d.nodestrokecol); })
          .attr("stroke-width", 0.5)
          .attr("opacity",function(d) { return d.nodeopacity; })
          .attr("fill", function(d) { return d3.rgb(d.nodecol); });


      node.append("text")
          .attr("dy", ".31em")
          .attr("font-family","Helvetica")
          .attr("font-color","black")
          .attr("stroke-width", 0.0)
          .attr("font-size",function(d) { return d.textsize; })
          .attr("text-anchor", function(d) { return d.x < 180 ? "start" : "end"; })
          .attr("transform", function(d) { return d.x < 180 ? "translate(8)" : "rotate(180)translate(-8)"; })
          .text(function(d) { return d.name; });
    });

    function mouseover() {
      d3.select(this).select("circle").transition()
          .attr("r", 20);
      d3.select(this).select("text").transition()
          .attr("font-size", "40px");
    }

    function mouseout() {
      d3.select(this).select("circle").transition()
          .attr("r", function(d) { return d.noderadius; });
      d3.select(this).select("text").transition()
          .attr("font-size", function(d) { return d.textsize; });
    }


    d3.select(self.frameElement).style("height", radius * 2 + "px");

    // Code to download svg
    // Code adapted from (http://bl.ocks.org/duopixel/3831266)
     d3.select("#downloadcircle").on("click", function(){
       d3.select(this)
        .attr("href", 'data:application/octet-stream;base64,' + btoa(unescape(encodeURIComponent(d3.select("#circlelayout").html().replace("&nbsp;", "")))))
        .attr("download", "CORAL.circle.svg") ;
    });

    // Create pseudo-element with the legend and add it to the SVG
    var pseudoSVG = $(
      '<div>' +
      '<svg xmlns="http://www.w3.org/2000/svg">' +
      '<g>'+ root.legend + '</g>' + 
      '</svg>' +
      '</div>'
    );
    $("div#forcelayout svg").append(pseudoSVG.find('svg g'));
    //////////.JS//////////

    //closing if statement
  }
  //closing binding
};

//Identify the class that this js modifies below in ....(binding, "CLASSNAME");....
//register the output binding
Shiny.outputBindings.register(binding, "circleNetwork");
