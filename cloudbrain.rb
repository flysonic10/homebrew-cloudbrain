class Cloudbrain < Formula
  desc "Platform for real-time sensor data analysis and visualization."
  homepage "http://demo.cloudbrain.rocks"
  url "https://pypi.python.org/packages/source/c/cloudbrain/cloudbrain-0.2.1.tar.gz"
  sha256 "0780d28ebb32f0759d56f1ed39629c977a23640ff0c952479593fbc9b72c65a4"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "liblo"

  resource "pika" do
    url "https://pypi.python.org/packages/source/p/pika/pika-0.10.0b2.tar.gz"
    sha256 "f54e133dc0130420889e64cf0f2df8d6c7a67647c37a80b4f56350bd3a83d29a"
  end

  resource "pyliblo" do
    url "http://das.nasophon.de/download/pyliblo-0.9.2.tar.gz"
    sha256 "382ee7360aa00aeebf1b955eef65f8491366657a626254574c647521b36e0eb0"
  end

  resource "pyserial" do
    url "https://pypi.python.org/packages/source/p/pyserial/pyserial-2.7.tar.gz"
    sha256 "3542ec0838793e61d6224e27ff05e8ce4ba5a5c5cc4ec5c6a3e8d49247985477"
  end

  def install
    # Dependencies
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[pika pyliblo pyserial].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # Cloudbrain
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "false"
  end
end
