'use strict';

var path = require('path');
var webpack = require('webpack');
var merge = require('webpack-merge');
var autoprefixer = require('autoprefixer');

var HtmlWebpackPlugin = require('html-webpack-plugin');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var CopyWebpackPlugin = require('copy-webpack-plugin');

var TARGET_ENV = process.env.npm_lifecycle_event === 'build' ? 'production' : 'development';

console.log("TARGET_ENV : " + TARGET_ENV);

var common = {
  output: {
    path: path.resolve(__dirname, 'dist/'),
    filename: '[hash].js'
  },
  resolve: {
    modulesDirectories: ['node_modules'],
    extensions : ['', '.js', '.elm']
  },
  module: {
    noParse: /\.elm$/,
    loaders: [
    {
      test: /\.(jpe?g|png|gif|ttf|eot|svg|woff|woff2)$/,
      loader: 'file-loader'
    },
    ]
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: 'src/static/index.html',
      inject: 'body',
      filename: 'index.html'
    })
  ],
  postcss: [ autoprefixer( { browsers : ['last 2 versions'] } ) ]
}

if (TARGET_ENV === 'development') {
  console.log('development server');
  module.exports = merge(common, {
    entry: [
      'webpack-dev-server/client?http://0.0.0.0:3000',
      path.join(__dirname, 'src/static/index.js')
    ],

    devServer: {
      inline: true,
      progress: true,
      stats: { colors: true }
    },

    module: {
      loaders: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-hot!elm-webpack?verbose=true&warn=true'
      },
      {
        test: /\.(css|scss)$/,
        loaders: [
          'style-loader',
          'css-loader',
          'postcss-loader',
          'sass-loader'
        ]
      }
      ]
    }
  });
}

if (TARGET_ENV === 'production') {
  console.log('building for production');
  module.exports = merge(common, {

    entry: path.join(__dirname, 'src/static/index.js'),
    module: {
      loaders: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-webpack'
      },
      {
        test: /\.(css|scss)$/,
        loader: ExtractTextPlugin.extract('style-loader', [
            'css-loader',
            'postcss-loader',
            'sass-loader'
        ])
      }
      ]
    },

    plugins: [
      new CopyWebpackPlugin([
          {
            from: 'src/static/img',
            to: 'static/img'
          },
          {
            from: 'src/favicon.ico'
          }
      ]),
      new webpack.optimize.OccurenceOrderPlugin(),

      new ExtractTextPlugin('./[hash].css', { allChunks : true }),

      new webpack.optimize.UglifyJsPlugin({
        minimize: true,
        compressor: { warnings: false },
        //mangle: true
      })
    ]

  });
}

