defmodule Exred.Node.Rpiphoto do
  @moduledoc """
  Takes a photo using the Raspberry PI's camera module
  """

  @name "RPI Photo"
  @category "raspberryPi"
  @info @moduledoc
  @config %{
    name: %{
      info: "Node name",
      value: @name,
      type: "string",
      attrs: %{max: 25}
    },
    filename: %{
      info: "Output file name",
      value: "/tmp/image-%04d",
      type: "string",
      attrs: %{max: 25}
    },
    width: %{
      info: "image width",
      type: "number",
      value: 800,
      attrs: %{min: 0, max: 3280}
    },
    height: %{
      info: "image height",
      type: "number",
      value: 600,
      attrs: %{min: 0, max: 2464}
    },
    horizontal_flip: %{
      info: "Flip image horizontally",
      type: "string",
      value: "false",
      attrs: %{max: 5}
    },
    vertical_flip: %{
      info: "Flip image vertically",
      type: "string",
      value: "false",
      attrs: %{max: 5}
    },
    metering: %{
      info: "Set metering mode",
      type: "selector",
      value: "average",
      attrs: %{options: ["average", "spot", "backlit", "matrix"]}
    },
  }
  @ui_attributes %{
    left_icon: "photo_camera",
    config_order: [:name, :filename, :width, :height]
  }
  
  
  use Exred.Library.NodePrototype
  alias Porcelain.Result
  require Logger

  
  @impl true
  def handle_msg(msg, state) do
    filename = Map.get msg, :filename, state.config.filename.value
    width    = Map.get msg, :width, state.config.width.value
    height   = Map.get msg, :height, state.config.height.value
    metering = Map.get msg, :metering, state.config.metering.value
    
    horizontal_flip = case Map.get(msg, :horizontal_flip, state.config.horizontal_flip.value) do
      "true" -> "-hf"
      _      -> ""
    end
    vertical_flip = case Map.get(msg, :vertical_flip, state.config.vertical_flip.value) do
      "true" -> "-vf"
      _      -> ""
    end
    
    cmd = [ "/usr/bin/raspistill",
      "-dt",
      "-v" ,
      "-o", filename,
      "-w", width,
      "-h", height,
      "-mm", metering,
      "-ex", "sports",
      "-awb", "cloud",
      "--nopreview",
      horizontal_flip,
      vertical_flip,
      "--timeout", "100"
    ] |> Enum.join(" ")
    
    res = %Result{out: output, status: status} = Porcelain.shell( cmd )
    Logger.info "#{__MODULE__} raspistill return status: #{inspect status}"
    out = put_in msg, [:payload, :exit_status], status

    {out, state}
  end


end
